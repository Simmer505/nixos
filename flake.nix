{
    description = "NixOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = inputs@{ self, nixpkgs, home-manager, ... }: let
        inherit (self) outputs;

        configs."ankaa" = {
            system = "x86_64-linux";
            
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

            games.enable = true;

            common.nil.enable = true;

            networking.wireguard.enable = true;


        };

        configs."alpheratz" = {
            system = "x86_64-linux";
            
            audio = {
                pipewire.enable = true;
                music.enable = true;

                gui = {
                    enable = true;
                    protonmail = true;
                    matrix = true;

                    monitors = utils.mkMonitor {
                        monitor = "eDP-1";
                        resolution = "1920x1200";
                        refreshRate = 60;
                    };

                };
            };

            common.nil.enable = true;

            networking.wireguard.enable = true;
        };

        configs."default-hostname" = {

        };

        hostname = 
            if (builtins.pathExists ./hostname) then
                builtins.readFile(./hostname)
            else
                "default-hostname";

        utils = import ./utils;
        system = configs."${hostname}".system;
        pkgs = nixpkgs.legacyPackages.${system};



        in {
        nixosConfigurations = {
            "${hostname}" = nixpkgs.lib.nixosSystem {
                specialArgs = {
                    inherit (outputs) localPackages;
                };
                modules = [
                    {
                        networking.hostName = hostname;
                    }
                    (import ./modules/nix)
                    {
                        simmer = configs."${hostname}";
                    }
                    (./. + "/hosts/${hostname}/system.nix")
                    (./. + "/hosts/${hostname}/hardware-configuration.nix")
                    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.extraSpecialArgs = { 
                            systemConfig = configs."${hostname}";
                            inherit utils;
                        };

                        home-manager.users.eesim = import (./. + "/hosts/${hostname}/home.nix");
                    }
                ];
            };
        };
        localPackages = nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
            {
                kickoff-dot-desktop = pkgs.callPackage ./pkgs/kickoff-dot-desktop.nix { };
                gamescope-old = pkgs.callPackage ./pkgs/gamescope-old {};
                gamescope-dbg = pkgs.callPackage ./pkgs/gamescope-dbg {};
            }
        );
    };
}
