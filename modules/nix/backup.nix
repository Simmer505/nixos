{ pkgs
, lib
, config
, ...
}:

with lib; let
    cfg = config.simmer.backup;
in
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
            description = "path to file containing passphrase";
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

    config = mkIf cfg.enable {
        services.borgbackup.jobs = {
            backup = {
                user = cfg.user;
                paths = cfg.paths;
                exclude = cfg.excludes;
                repo = cfg.repo;
                encryption = {
                    mode = "repokey-blake2";
                    passCommand = "cat ${cfg.passphrase}";
                };
                environment.BORG_RSH = "ssh -i ${cfg.key}";
                compression = "auto,lzma";
                startAt = cfg.repeat;
            };
        };
    };
}
