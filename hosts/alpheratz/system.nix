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

    nixpkgs = {
        overlays = [];
        config = {
            allowUnfree = true;
        };
    };

    nix = {
        settings = {
            experimental-features = "nix-command flakes";
        };
    };

    sops = {
        defaultSopsFile = ../../secrets/alpheratz/secrets.yaml;
        age.keyFile = "/home/eesim/.config/sops/age/keys.txt";

        secrets."wireguard/private" = {};
        secrets."wireguard/preshared" = {};
    };

    environment.systemPackages = [
        localPackages.x86_64-linux.jhelioviewer
        ];

    services.printing.enable = true;
    services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
    };

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.xbootldrMountPoint = "/boot";
    boot.loader.efi.efiSysMountPoint = "/efi";
    boot.loader.efi.canTouchEfiVariables = true;

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    fileSystems = {
        "/".options = [ "compress=zstd" ];
        "/home".options = [ "compress=zstd" ];
        "/nix".options = [ "compress=zstd" "noatime" ];
    };

    networking.wg-quick.interfaces = {
        wg0 = {
            address = [ "10.0.0.2/32" ];
            listenPort = 51820;
            privateKeyFile = "/run/secrets/wireguard/private";
            dns = [ "192.168.1.1" ];
            autostart = false;

            peers = [
                {
                    publicKey = "sWdXHlBqH+tAgSl0Tqr46sfKvgFN/vMDiuN08HjzaSg=";
                    presharedKeyFile = "/run/secrets/wireguard/preshared";
                    allowedIPs = [ "0.0.0.0/0" "::/0" ];
                    endpoint = "jellyfin.simmer505.com:51820";
                }
            ];
        };
    };

    # Set your time zone.
    time.timeZone = "America/Chicago";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    # Define a user account.
    users.users.eesim = {
        isNormalUser = true;
        extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
        shell = pkgs.fish;
    };

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];

    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "23.11"; # Did you read the comment?

}

