{
    description = "NixOS configuration";

    inputs = {
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager-stable.url = "github:nix-community/home-manager/release-24.11";
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
                     , llama-cpp
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
                                "/home/eesim/llama/models"
                                "/home/eesim/.local/share/Trash"
                                "/home/eesim/Games"
                                "/home/eesim/nixpkgs"
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

                        term = {
                          terminal = "kitty";
                          font = "codelia";
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
                            citrix = false;
                        };

                        games = {
                            enable = true;
                            lutris.enable = true;
                            minecraft.enable = true;
                        };

                        common.nil.enable = true;

                        networking = {
                            wireguard.enable = true;
                            firewall.allowedTCPPorts = [ 8080 ];
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
                            citrix = false;
                        };

                        games = {
                          enable = true;
                        };
 
                        backup = {
                           user = "eesim";
                           paths = [ "/home/eesim" ];
                           repo = "t643s856@t643s856.repo.borgbase.com:repo";
                           excludes = [
                              "/home/eesim/.cache/"
                              "/home/eesim/configs/mc-distant-horizons"
                              "/home/eesim/configs/mc-arcadia"
                           ];
                           key = "/home/eesim/.ssh/id_ed25519";
                           passphrase = "/run/secrets/borgbase/nix-alpheratz";
                           repeat = "daily";
                        };

                        common.nil.enable = true;

                        networking = {
                            wireguard.enable = true;
                        };

                        term.terminal = "kitty";
                    };
                }
                {
                    hostname = "diphda";
                    system = "x86_64-linux";
                    nixpkgs = nixpkgs-stable;
                    home-manager = home-manager-stable;

                    options = {
                        openssh.enable = true;

                        backup = {
                          enable = true;
                          user = "eesim";
                          paths = [ "/home/eesim" ];
                          repo = "ssh://p9h977h3@p9h977h3.repo.borgbase.com/./repo";
                          excludes = [
                            "/home/eesim/.cache"
                          ];
                          passphrase = "/run/secrets/backup/repo_password";
                          key = "/home/eesim/.ssh/id_ed25519_borgbase";
                          repeat = "daily";
                        };

                        networking = {
                            firewall = {
                                allowedTCPPorts = [ 80 443 3000 3843 4533 5030 6600 6722 7474 7878 8000 8080 8081 8083 8089 8096 8120 8181 8443 8787 8889 8902 8989 8998 9000 9091 9696 11112 13378 24454 25565 25600 50300 ];
                                allowedUDPPorts = [ 3478 10001 ];
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
                        overlays = with overlays; [ printrun shadps4 ];
                        config = {
                          allowUnfree = true;
                          permittedInsecurePackages = [
                            "electron-31.7.7"
                          ];
                        };
                    };

                    localPackages = pkgs.lib.genAttrs flake-utils.lib.defaultSystems (system: {
                            kickoff-dot-desktop = pkgs.callPackage ./pkgs/kickoff-dot-desktop.nix {};
                            jhelioviewer = pkgs.callPackage ./pkgs/jhelioviewer.nix {};
                            llama-cpp = llama-cpp.packages.${system}.rocm;
                            shadps4 = pkgs.callPackage ./pkgs/shadps4.nix {};
                            gazou = pkgs.callPackage ./pkgs/gazou.nix {};
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
                                    inherit localPackages;
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
