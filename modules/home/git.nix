{ lib
, pkgs
, config
, ...
}:

with lib; let
    cfg = config.simmer.git;
in
{
    options.simmer.git = {
        enable = mkOption {
            description = "Whether to install and configure git";
            type = types.bool;
            default = true;
        };
    };

    config = mkIf cfg.enable {
        programs.git = {
            enable = true;
            userName = "Ethan Simmons";
            userEmail = "eesimmons9105@gmail.com";
        };
    };
}
