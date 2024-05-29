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
    ];

    programs.sway.enable = true;
    programs.thunar.enable = true;

    xdg.portal.wlr.enable = true;

    fonts.packages = with pkgs; [
        font-awesome
    ];
}
