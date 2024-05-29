{ pkgs, lib, ... }: {
    services.borgbackup.jobs = {
        home-ankaa = 
        let
            user = "eesim";
            home = "/home/${user}";
            excludes = [ ".local/share/Steam/steamapps/common" ".cache" ];
        in
            {
                inherit user;
                paths = [ home ];
                exclude = builtins.map (e: "${home}/${e}") excludes;
                repo = "rf030789@rf030789.repo.borgbase.com:repo";
                encryption = {
                    mode = "repokey-blake2";
                    passCommand = "cat ${home}/.ssh/borgbase_passphrase";
                };
                environment.BORG_RSH = "ssh -i ${home}/.ssh/id_ed25519_borgbase";
                compression = "auto,lzma";
                startAt = "daily";
            };
    };
}
