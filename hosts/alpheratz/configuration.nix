# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ 
    inputs,
    outputs,
    lib,
    config,
    pkgs,
    ...
}: {

    imports = [
        ./hardware-configuration.nix
    ]; 

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

    networking.hostName = "alpheratz";
    networking.networkmanager.enable = true;
    networking.nameservers = [ "192.168.0.100" ];
    networking.firewall = {
        allowedUDPPorts = [ 51820 ];
    };
    networking.wg-quick.interfaces = {
        wg0 = {
            address = [ "10.6.0.5" ];
            listenPort = 51820;
            privateKeyFile = "/root/wireguard-keys/wg0/private";
            dns = [ "10.2.0.100" ];

            peers = [
                {
                    publicKey = "pEWHugUnnhWXkJzCIhXryRRZMoCAuvAITDeP4ItenQk=";
                    presharedKeyFile = "/root/wireguard-keys/wg0/preshared";
                    allowedIPs = [ "10.2.0.0/24" "192.168.0.0/24" ];
                    endpoint = "jellyfin.simmer505.com:51820";
                    persistentKeepalive = 25;
                }
            ];
        };
    };

    # Set your time zone.
    time.timeZone = "America/Chicago";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    services.xserver.xkb.layout = "us";
    services.xserver.xkb.options = "caps:escape";

    fonts.packages = with pkgs; [
        font-awesome
    ];

    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    # List packages installed in system profile. To search, run:
    environment.systemPackages = with pkgs; with outputs.packages.x86_64-linux; [
        wget
        curl
        ldns
        git
        killall
        vim
        wl-clipboard
        grim
        slurp
        waybar
        alacritty
        kickoff
        firefox
        bottom
        eza
        ripgrep
        fzf
        mpv
        wireguard-tools
        pulseaudio
        eza
        pavucontrol
        kickoff-dot-desktop
    ];

    programs.sway.enable = true;
    programs.fish.enable = true;
    programs.thunar.enable = true;
    programs.light.enable = true;

    programs.neovim = {
        enable = true;
        defaultEditor = true;
    };

    xdg.portal.wlr.enable = true;

    # Define a user account.
    users.users.eesim = {
        isNormalUser = true;
        extraGroups = [ "wheel" "video" "audo" "networkmanager" ];
        packages = with pkgs; [];
        shell = pkgs.fish;
    };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    # Enable sound.
    # sound.enable = true;
    # hardware.pulseaudio.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];

    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "23.11"; # Did you read the comment?

}

