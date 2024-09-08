{
    description = "NixOS configuration";

    inputs = {
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager-stable.url = "github:nix-community/home-manager/release-24.05";
        home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

        home-manager-unstable.url = "github:nix-community/home-manager";
        home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

        flake-utils.url = "github:numtide/flake-utils";

        sops-nix.url = "github:Mic92/sops-nix";

        llama-cpp.url = "github:ggerganov/llama.cpp";

    };

    outputs = inputs@{ self
                     , nixpkgs-stable
                     , nixpkgs-unstable
                     , home-manager-stable
                     , home-manager-unstable
                     , flake-utils
                     , sops-nix
                     , ...
                     }:
        let
            inherit (self) outputs;
            lib = nixpkgs-stable.lib;

            overlays = import ./overlays { inherit inputs; };
            utils = import ./utils;

            configs = [
                {
                    hostname = "ankaa";
                    system = "x86_64-linux";
                    nixpkgs = nixpkgs-unstable;
                    home-manager = home-manager-unstable;
                    
                    options = {
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
                            gtk = false;

                            sway = {
                                enable = true;
                                desktop = true;
                            };

                            monitors = lib.mkMerge [
                                (utils.mkMonitor {
                                    monitor = "DP-2";
                                    resolution = "3440x1440";
                                    refreshRate = 144;
                                    wallpaper = "solar_system.png";
                                })
                                (utils.mkMonitor {
                                    monitor = "HDMI-A-1";
                                    resolution = "1920x1080";
                                    x = 3440;
                                    refreshRate = 75;
                                })
                            ];

                        };

                        school = {
                            enable = true;
                            citrix.enable = true;
                        };

                        games = {
                            enable = true;
                            lutris.enable = true;
                            minecraft.enable = true;
                        };

                        common.nil.enable = true;

                        networking = {
                            wireguard.enable = true;
                        };
                    };
                }
                {
                    hostname = "alpheratz";
                    system = "x86_64-linux";
                    nixpkgs = nixpkgs-unstable;
                    home-manager = home-manager-unstable;

                    options = {
                        laptop = {
                            powersave.enable = true;
                            backlight.enable = true;
                        };
                        
                        audio = {
                            pipewire.enable = true;
                            music.enable = true;
                        };

                        gui = {
                            enable = true;
                            protonmail = true;

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

                        school = {
                            enable = true;
                            citrix = true;
                        };

                        common.nil.enable = true;

                        networking = {
                            wireguard.enable = true;
                        };
                    };
                }
                {
                    hostname = "diphda";
                    system = "x86_64-linux";
                    nixpkgs = nixpkgs-stable;
                    home-manager = home-manager-stable;

                    options = {
                        openssh.enable = true;

                        networking = {
                            firewall = {
                                allowedTCPPorts = [ 80 443 4533 6722 7878 8080 8081 8083 8089 8096 8181 8787 8902 8989 9000 9696 11112 24454 25565 25600 ];
                            };
                        };
                    };
                }
            ];

        in {
            nixosConfigurations = builtins.listToAttrs (map (config: 
                let 
                    inherit (config) nixpkgs home-manager system hostname;

                    pkgs = import nixpkgs {
                        inherit system;
                        overlays = with overlays; [];
                        config.allowUnfree = true;
                    };

                    localPackages = pkgs.lib.genAttrs flake-utils.lib.defaultSystems (system: {
                            kickoff-dot-desktop = pkgs.callPackage ./pkgs/kickoff-dot-desktop.nix {};
                            gamescope-old = pkgs.callPackage ./pkgs/gamescope-old {};
                            gamescope-dbg = pkgs.callPackage ./pkgs/gamescope-dbg {};
                            jhelioviewer = pkgs.callPackage ./pkgs/jhelioviewer.nix {};
                        }
                    );

                    systemConfig = if builtins.pathExists (./. + "/hosts/${hostname}/system.nix") then
                        (./. + "/hosts/${hostname}/system.nix")
                    else
                        ./hosts/default/system.nix;

                    homeConfig = if builtins.pathExists (./. + "/hosts/${hostname}/home.nix") then
                        (./. + "/hosts/${hostname}/home.nix")
                    else 
                        ./hosts/default/home.nix;
                in
                {
                    name = config.hostname;
                    value = nixpkgs.lib.nixosSystem {
                        specialArgs = {
                            inherit localPackages;
                            inherit pkgs;
                        };
                        modules = [
                            {
                                networking.hostName = hostname;
                                simmer = config.options;
                                nix.settings.trusted-users = [ "eesim" ];
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
                                    systemConfig = config.options;
                                };

                                home-manager.users.eesim = import homeConfig;
                            }
                        ];
                    };
                })
                configs
            );
        };
}
