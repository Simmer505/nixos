{ lib
, pkgs
, config
, localPackages
, ... 
}: 
with lib;
let
    cfg = config.simmer.games;
in
{
    options.simmer.games = {
        enable = mkOption {
            description = "Whether to enable games";
            type = types.bool;
            default = false;
        };

        protonup.enable = mkOption {
            description = "Whether to install protonup";
            type = types.bool;
            default = true;
        };

        lutris.enable = mkOption {
            description = "Whether to install lutris";
            type = types.bool;
            default = false;
        };

        steam.enable = mkOption {
            description = "Whether to install steam";
            type = types.bool;
            default = true;
        };

        minecraft.enable = mkOption {
            description = "Whether to install minecraft launcher";
            type = types.bool;
            default = false;
        };

        gamescope.enable = mkOption {
            description = "Whether to install gamescope";
            type = types.bool;
            default = cfg.steam.enable;
        };

        discord.enable = mkOption {
            description = "Whether to install discord";
            type = types.bool;
            default = true;
        };
    };
}
