{
    description = "NixOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = inputs@{ self, nixpkgs, home-manager, ... }: let
        inherit (self) outputs;

        hostname = 
            if (builtins.pathExists ./hostname) then
                builtins.readFile(./hostname)
            else
                "default-hostname";

        configs."ankaa" = {
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
            };

            games.enable = true;

            common.nil.enable = true;

            networking.wireguard.enable = true;

        };

        configs."alpheratz" = {
            audio = {
                pipewire.enable = true;
                music.enable = true;

                gui = {
                    enable = true;
                    protonmail = true;
                    matrix = true;
                };
            };

            common.nil.enable = true;

            networking.wireguard.enable = true;
        };

        configs."default-hostname" = {

        };

        in {
        nixosConfigurations = {
            "${hostname}" = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
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

                        home-manager.users.eesim = import (./. + "/hosts/${hostname}/home.nix");
                    }
                ];
            };
        };
        localPackages = nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
            let
                pkgs = nixpkgs.legacyPackages.${system};
            in
            {
                kickoff-dot-desktop = pkgs.callPackage ./pkgs/kickoff-dot-desktop.nix { };
                gamescope-old = pkgs.callPackage ./pkgs/gamescope-old {};
                gamescope-dbg = pkgs.callPackage ./pkgs/gamescope-dbg {};
            }
        );
    };
}
