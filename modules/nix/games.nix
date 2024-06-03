{ lib
, pkgs
, config
, localPackages
, ... 
}: 
with lib; let
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

    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; with localPackages.x86_64-linux;
        []
        ++ optional cfg.protonup.enable protonup-qt
        ++ optional cfg.gamescope.enable gamescope-old
        ++ optional cfg.discord.enable vesktop
        ++ optionals cfg.lutris.enable [ lutris wine ];

        programs.steam = mkIf cfg.steam.enable {
            enable = true;
        };
    };
}
