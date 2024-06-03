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
    ];
}
