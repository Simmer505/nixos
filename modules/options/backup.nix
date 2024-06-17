
{ pkgs
, lib
, config
, ...
}:

with lib;
{
    options.simmer.backup = {
        enable = mkOption {
            description = "Whether backups should be enabled";
            type = types.bool;
            default = false;
        };

        repo = mkOption {
            description = "Which repository to backup to";
            type = types.str;
        };

        paths = mkOption {
            description = "Which paths to backup";
            type = types.listOf types.str;
        };

        user = mkOption {
            description = "Which user to run backup commands with";
            type = types.str;
            default = "root";
        };

        excludes = mkOption {
            description = "Which directories to exclude";
            type = types.listOf types.str;
            default = [];
        };

        passphrase = mkOption {
            description = "Path to file containing passphrase";
            type = types.path;
        };

        key = mkOption {
            description = "Path to file containing SSH Key";
            type = types.path;
        };

        repeat = mkOption {
            description = "How often to run the backup (hourly, daily, weekly)";
            type = types.enum [ "hourly" "daily" "weekly" ];
        };

    };
}
