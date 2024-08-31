{ lib
, pkgs
, config
, ...
}:

{
    imports = [
        ./audio.nix
        ./backup.nix
        ./common.nix
        ./games.nix
        ./gui.nix
        ./networking.nix
        ./openssh.nix
        ./system.nix
        ./laptop.nix
        ./school.nix
    ];
}
