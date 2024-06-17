
{ lib
, pkgs
, localPackages
, config
, ...
}: 

with lib;
{
    options.simmer.common = {
        neovim.enable = mkOption {
            description = "Whether to install neovim and set as default editor";
            type = types.bool;
            default = true;
        };
        
        nil.enable = mkOption {
            description = "Whether to install nil";
            type = types.bool;
            default = true;
        };

        shell = mkOption {
            description = "Default shell to use (fish)";
            type = types.enum [ "fish" ];
            default = "fish";
        };

        caps = mkOption {
            description = "What key to bind caps lock to";
            type = types.enum [ "ctrl-esc" "esc" "caps" ];
            default = "ctrl-esc";
        };

        nixpkgs = mkOption {
            description = "Which nixpkgs version to use";
            type = types.any;
        };
    };
}
