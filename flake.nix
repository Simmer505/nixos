{
    description = "NixOS configuration";

    inputs = {
        currentSystem.url = "path:/etc/nixos/hostname";

        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager-stable.url = "github:nix-community/home-manager/release-24.05";
        home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

        home-manager-unstable.url = "github:nix-community/home-manager";
        home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

        flake-utils.url = "github:numtide/flake-utils";

        sops-nix.url = "github:Mic92/sops-nix";

    };

    outputs = inputs@{ self
                     , currentSystem
                     , nixpkgs-stable
                     , nixpkgs-unstable
                     , home-manager-stable
                     , home-manager-unstable
                     , flake-utils
                     , sops-nix
                     , ...
                     }: let
        inherit (self) outputs;
        inherit (currentSystem) hostname;

        overlays = import ./overlays { inherit inputs; };
        utils = import ./utils;

        configs."ankaa" = {
            system = "x86_64-linux";
            common.nixpkgs = "unstable";
            
            openssh = {
                enable = true;
                port = 2222;
            };

            backup = {
                enable = true;
                user = "eesim";
                paths = [ "/home/eesim" ];
                repo = "rf030789@rf030789.repo.borgbase.com:repo";
                excludes = [ 
                    "/home/eesim/.local/share/Steam/steamapps/common"
                    "/home/eesim/.cache"
                ];
                passphrase = "/home/eesim/.ssh/borgbase_passphrase";
                key = "/home/eesim/.ssh/id_ed25519_borgbase";
                repeat = "daily";
            };

            audio = {
                pipewire.enable = true;
                music.enable = true;
                tools = {
                    helvum = true;
                    easyeffects = true;
                };
            };

            gui = {
                enable = true;
                protonmail = true;
                matrix = true;
                gtk = false;

                sway = {
                    enable = true;
                    desktop = true;
                };

                monitors = pkgs.lib.mkMerge [
                    (utils.mkMonitor {
                        monitor = "DP-2";
                        resolution = "3440x1440";
                        refreshRate = 144;
                        x = 1920;
                        wallpaper = "ship_moon.png";
                    })
                    (utils.mkMonitor {
                        monitor = "HDMI-A-1";
                        resolution = "1920x1080";
                        refreshRate = 75;
                    })
                ];

            };

            games = {
                enable = true;
                lutris.enable = true;
                minecraft.enable = true;
            };

            common.nil.enable = true;

            networking = {
                wireguard.enable = true;
                nameservers = [ "192.168.0.100" ];
            };


        };

        configs."alpheratz" = {
            system = "x86_64-linux";
            common.nixpkgs = "unstable";
            
            audio = {
                pipewire.enable = true;
                music.enable = true;
            };

            gui = {
                enable = true;
                protonmail = true;
                matrix = true;

                sway = {
                    enable = true;
                    desktop = false;
                };

                monitors = utils.mkMonitor {
                    monitor = "eDP-1";
                    resolution = "1920x1200";
                    refreshRate = 60;
                };

            };

            common.nil.enable = true;

            networking = {
                wireguard.enable = true;
                nameservers = [ "192.168.0.100" ];
            };
        };

        configs.diphda = {
            system = "x86_64-linux";
            common.nixpkgs = "stable";

            openssh.enable = true;

            gui = {
                enable = false;
                sway.enable = false;
            };

            networking = {
                firewall = {
                    allowedTCPPorts = [ 80 443 25565 24454 8089 ];
                };
            };
        };

        currentConfig = configs."${hostname}";
        system = currentConfig.system;

        nixpkgs = if currentConfig.common.nixpkgs == "unstable" then
            nixpkgs-unstable
        else
            nixpkgs-stable;

        home-manager = if currentConfig.common.nixpkgs == "unstable" then
            home-manager-unstable
        else
            home-manager-stable;

        pkgs = import nixpkgs {
                inherit system;
                overlays = with overlays; [ gamescope ];
                config.allowUnfree = true;
            };


        systemConfig = if builtins.pathExists (./. + "/hosts/${hostname}/system.nix") then
            (./. + "/hosts/${hostname}/system.nix")
        else
            ./hosts/default/system.nix;

        homeConfig = if builtins.pathExists (./. + "/hosts/${hostname}/home.nix") then
            (./. + "/hosts/${hostname}/home.nix")
        else 
            ./hosts/default/home.nix;

        in {
            nixosConfigurations = {
                "${hostname}" = nixpkgs.lib.nixosSystem {
                    specialArgs = {
                        inherit (outputs) localPackages;
                        inherit pkgs;
                    };
                    modules = [
                        {
                            networking.hostName = hostname;
                            simmer = currentConfig;
                        }
                        systemConfig
                        (./. + "/hosts/${hostname}/hardware-configuration.nix")
                        sops-nix.nixosModules.sops
                        (import ./modules/nix)
                        (import ./modules/options)
                        home-manager.nixosModules.home-manager
                        {
                            home-manager.useGlobalPkgs = true;
                            home-manager.useUserPackages = true;
                            home-manager.extraSpecialArgs = { 
                                inherit utils;
                                systemConfig = configs."${hostname}";
                            };

                            home-manager.users.eesim = import homeConfig;
                        }
                    ];
                };
            };
            localPackages = pkgs.lib.genAttrs flake-utils.lib.defaultSystems (system:
                {
                    kickoff-dot-desktop = pkgs.callPackage ./pkgs/kickoff-dot-desktop.nix {};
                    gamescope-old = pkgs.callPackage ./pkgs/gamescope-old {};
                    gamescope-dbg = pkgs.callPackage ./pkgs/gamescope-dbg {};
                }
            );
        };
}
