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

    hardware.graphics.extraPackages = with pkgs; [
        rocmPackages.clr.icd
    ];

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    fileSystems = {
        "/".options = [ "compress=zstd" ];
        "/home".options = [ "compress=zstd" ];
        "/nix".options = [ "compress=zstd" "noatime" ];
    };

    # Set your time zone.
    time.timeZone = "America/Chicago";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    programs.ssh.startAgent = true;

    # Define a user account.
    users.users.eesim = {
        isNormalUser = true;
        extraGroups = [ "wheel" "video" "audo" "networkmanager" ];
        packages = with pkgs; [];
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINfY1b8+mp6Y6k5taexTdBPTeZUcxT6RyP0jvc/74GyY eesim@Ethans-NAS"
        ];
    };

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    system.stateVersion = "23.11";

}

