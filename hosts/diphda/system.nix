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
        ];
    };

    system.stateVersion = "23.11";

}

