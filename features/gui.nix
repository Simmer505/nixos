{ lib, pkgs, localPackages, ... }: {

    environment.systemPackages = with pkgs; with localPackages.x86_64-linux; [
        wl-clipboard
        grim
        slurp
        swaybg
        waybar
        alacritty
        kickoff
        kickoff-dot-desktop
        wayland-pipewire-idle-inhibit
        firefox
        mpv
        cinny-desktop
        thunderbird
        protonmail-bridge
        libsecret
    ];

    programs.sway.enable = true;
    programs.thunar.enable = true;
    programs.dconf.enable = true;

    services.gnome.gnome-keyring.enable = true;
    services.dbus.packages = [ pkgs.gnome.seahorse ];

    xdg.portal.wlr.enable = true;

    fonts.packages = with pkgs; [
        font-awesome
    ];
}
