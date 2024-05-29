{
    description = "NixOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = inputs@{ self, nixpkgs, home-manager, ... }: let
        inherit (self) outputs;
    in {
        nixosConfigurations = {
            ankaa = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = {
                    inherit (outputs) localPackages;
                    openssh-port = 2222;
                };
                modules = [
                    ./hosts/ankaa/configuration.nix
                    ./hosts/ankaa/hardware-configuration.nix
                    ./features/audio.nix
                    ./features/common.nix
                    ./features/gui.nix
                    ./features/networking.nix
                    ./features/gaming.nix
                    ./modules/backups/home-ankaa.nix
                    ./modules/openssh.nix
                    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;

                        home-manager.users.eesim = import ./hosts/ankaa/home.nix;
                    }
                ];
            };
            alpheratz = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = {
                    inherit (outputs) localPackages;
                };
                modules = [
                    ./hosts/alpheratz/configuration.nix
                    ./hosts/alpheratz/hardware-configuration.nix
                    ./features/common.nix
                    ./features/gui.nix
                    ./features/audio.nix
                    ./features/networking.nix
                    ./features/laptop.nix
                    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.eesim = import ./hosts/alpheratz/home.nix;
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
            }
        );
    };
}
