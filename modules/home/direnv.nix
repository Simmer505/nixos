{ lib
, pkgs
, config
, ...
}:

with lib; let
    cfg = config.simmer.direnv;
in
{
    options.simmer.direnv = {
        enable = mkOption {
            description = "Whether to install and configure direnv";
            type = types.bool;
            default = true;
        };
    };

    config = mkIf cfg.enable {
        programs.direnv = {
            enable = true;
            enableBashIntegration = true;
            nix-direnv.enable = true;
        };
    };
}
