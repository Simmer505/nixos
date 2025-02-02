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

        secrets."backup/repo_password" = {
          owner = "eesim";
        };

        secrets."mc-arcadia/repo_password" = {};
        secrets."mc-dh/repo_password" = {};

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
        secrets."caddy/porkbun_api_key" = {};
        secrets."caddy/porkbun_secret_key" = {};
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
        beets-unstable
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

