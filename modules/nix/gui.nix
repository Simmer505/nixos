{ lib
, pkgs
, config
, localPackages
, ... 
}: 

with lib; let
    cfg = config.simmer.gui;
in
{
    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; with localPackages.x86_64-linux; []
        ++ optionals cfg.sway.enable [
            wl-clipboard
            grim
            slurp
            waybar
            swaybg
            kickoff
            kickoff-dot-desktop
            wayland-pipewire-idle-inhibit
            firefox
            mpv
            feh
        ]
        ++ optional cfg.matrix cinny-desktop
        ++ optional cfg.secrets libsecret
        ++ optionals cfg.protonmail [ thunderbird protonmail-bridge ];

        programs.dconf.enable = mkIf cfg.secrets true;
        services.gnome.gnome-keyring.enable = mkIf cfg.secrets true;
        services.dbus.packages = mkIf cfg.secrets [ pkgs.seahorse ];

        # Remove when nixpkgs issue 143365 is fixed
        security.pam.services.swaylock = mkIf (!cfg.sway.desktop) {};

        xdg.portal.config.common = [ "wlr" "gtk" ];
        programs.thunar.enable = true;

        hardware.opengl.enable = true;

        fonts = {
            packages = with pkgs; [
                liberation_ttf
                noto-fonts
                noto-fonts-cjk-sans
                noto-fonts-extra
                ubuntu_font_family
                vazir-fonts
                font-awesome
                corefonts
                carlito
            ];
             fontconfig = {

                defaultFonts = {
                    serif = [ "Noto Serif" "Noto Serif CJK JP" ];
                    sansSerif = [ "Noto Sans" "Noto Sans CJK JP" ];
                    monospace = [ "Ubuntu Mono" "Noto Sans Mono CJK JP" ];
                };
            };
        };
    };
}
