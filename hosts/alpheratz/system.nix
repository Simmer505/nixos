# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ 
    lib,
    config,
    pkgs,
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

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.xbootldrMountPoint = "/boot";
    boot.loader.efi.efiSysMountPoint = "/efi";
    boot.loader.efi.canTouchEfiVariables = true;

    powerManagement.powertop.enable = true;

    fileSystems = {
        "/".options = [ "compress=zstd" ];
        "/home".options = [ "compress=zstd" ];
        "/nix".options = [ "compress=zstd" "noatime" ];
    };

    # networking.wg-quick.interfaces = {
    #     wg0 = {
    #         address = [ "10.6.0.5" ];
    #         listenPort = 51820;
    #         privateKeyFile = "/root/wireguard-keys/wg0/private";
    #         dns = [ "10.2.0.100" ];

    #         peers = [
    #             {
    #                 publicKey = "pEWHugUnnhWXkJzCIhXryRRZMoCAuvAITDeP4ItenQk=";
    #                 presharedKeyFile = "/root/wireguard-keys/wg0/preshared";
    #                 allowedIPs = [ "10.2.0.0/24" "192.168.0.0/24" ];
    #                 endpoint = "simmer505.com:51820";
    #                 persistentKeepalive = 25;
    #             }
    #         ];
    #     };
    # };

    # Set your time zone.
    time.timeZone = "America/Chicago";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    # Define a user account.
    users.users.eesim = {
        isNormalUser = true;
        extraGroups = [ "wheel" "video" "audo" "networkmanager" ];
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

