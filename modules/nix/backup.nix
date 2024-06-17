{ pkgs
, lib
, config
, ...
}:

with lib; let
    cfg = config.simmer.backup;
in
{
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
