{ lib
, pkgs
, config
, ...
}:

{
    imports = [
        ./openssh.nix
        ./backup.nix
        ./audio.nix
        ./gui.nix
        ./common.nix
        ./networking.nix
        ./games.nix
    ];
}
