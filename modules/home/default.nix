{ lib
, pkgs
, config
, ...
}:

{
    imports = [
        ./git.nix
        ./direnv.nix
        ./git.nix
        ./qt.nix
        ./sway.nix
        ./gtk.nix
        ./term.nix
    ];
}
