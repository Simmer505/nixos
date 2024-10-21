# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ 
    lib,
    config,
    pkgs,
    localPackages,
    ...
}: {

    nix = {
        settings = {
            experimental-features = "nix-command flakes";
        };
    };

    sops = {
        defaultSopsFile = ../../secrets/diphda/secrets.yaml;
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

        secrets."mc-arcadia/repo_password" = {};
        secrets."tandoor/secret_key" = {
            owner = "tandoor";
        };
        secrets."tandoor/db_password" = {
            owner = "tandoor";
        };
        secrets."porkbun.keytab" = {
            format = "binary";
            sopsFile = ../../secrets/diphda/porkbun.keytab;
        };
        secrets."caddy-porkbun.keytab" = {
            format = "binary";
            sopsFile = ../../secrets/diphda/porkbun.keytab;
            path = "/home/eesim/configs/caddy/.env";
        };
    };

    systemd.timers."mc-arcadia-backup" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
            OnCalendar = "*-*-* *:00:00";
            Persistent = true;
        };
    };

    systemd.services."mc-arcadia-backup" = {
        enable = true;
        preStart = ''
            ${pkgs.docker}/bin/docker exec mc-arcadia-mc-1 mc-send-to-console say Server backup starting in 5 minutes
            sleep 5m
        '';
        postStart = ''
            ${pkgs.docker}/bin/docker exec mc-arcadia-mc-1 mc-send-to-console say Server backup starting
        '';
        serviceConfig = {
            Type = "oneshot"; 
            User = "root";
            ExecStart = ''
                systemd-inhibit --who="borgmatic" \
                --why="Prevent interrupting scheduled backup" \
                ${pkgs.borgmatic}/bin/borgmatic -c /etc/nixos/hosts/diphda/mc-arcadia-backup.yaml --verbosity 1 --syslog-verbosity 1
                '';
        };
    };

    systemd.services."dl-manager" = {
        enable = true;
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.bash pkgs.lftp ];
        serviceConfig = {
            Type = "simple";
            User = "eesim";
            Group = "acme";
            WorkingDirectory = "/home/eesim/scripts";
            ExecStart = ''
                /home/eesim/scripts/dl_manager_tokio -vv \
                    -c /var/lib/acme/download.simmer505.com/cert.pem \
                    -k /var/lib/acme/download.simmer505.com/key.pem \
                    --script-dir /home/eesim/scripts/ \
                    0.0.0.0:11112
            '';
        };
    };

    systemd.services."qbit-update-port" = {
        enable = true;
        path = [ pkgs.bash pkgs.docker pkgs.curl pkgs.netcat ];
        serviceConfig = {
            Type = "oneshot";
            User = "root";
            Group = "root";
            ExecStart = ''
                /home/eesim/configs/qbittorrent/update-port.sh
            '';
        };
    };

    systemd.timers."qbit-update-port" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
            OnCalendar = "*:0/5";
            Persistent = true;
        };
    };

    services.mpd = {
        enable = true;
        musicDirectory = "/media/Music";
        network.listenAddress = "any";
    };

    security.acme = {
        acceptTerms = true;
        defaults.email = "eesimmons9105@gmail.com";
        certs."download.simmer505.com" = {
            dnsProvider = "porkbun";
            environmentFile = "${config.sops.secrets."porkbun.keytab".path}";
        };
    };

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    fileSystems = {
        "/".options = [ "compress=zstd" ];
        "/home".options = [ "compress=zstd" ];
        "/nix".options = [ "compress=zstd" "noatime" ];
    };

    virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
    };

    environment.systemPackages = with pkgs; [
        docker-compose
    ];

    # Set your time zone.
    time.timeZone = "America/Chicago";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    # Define a user account.
    users.users.eesim = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEO9a9lCSa84Acv0SqOI608IJGa61dT5Frbw2Y/ABCB9 eesim@ankaa"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDvWgI2hkcjZvI9LcBEbH+1OuC3ULImTmd1qzOgcIuE7 eesim@alpheratz"
        ];
    };

    users.users.tandoor = {
        uid = 701;
        group = "services";
        extraGroups = [ "keys" ];
    };

    users.groups = {
        services = {
            gid = 1001;
        };
    };

    system.stateVersion = "23.11";

}

