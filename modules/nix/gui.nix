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

    options.simmer.gui = {
        enable = mkOption {
            description = "Enable gui";
            type = types.bool; 
            default = false;
        };

        wm = mkOption {
            description = "Which window manager to install";
            type = types.enum [ "sway" ];
            default = "sway";
        };

        terminal = mkOption {
            description = "Which terminal to install (alacritty)";
            type = types.enum [ pkgs.alacritty ];
            default = pkgs.alacritty;
        };

        protonmail = mkOption {
            description = "Whether to install protonmail bridge and mail application";
            type = types.bool;
            default = false;
        };

        secrets = mkOption {
            description = "Whether to enable secrets handling with gnomke-keyring";
            type = types.bool;
            default = cfg.protonmail;
        };

        matrix = mkOption {
            description = "Whether to install a matrix client";
            type = types.bool;
            default = false;
        };
    };


    config = mkIf cfg.enable {

        environment.systemPackages = with pkgs; with localPackages.x86_64-linux; []
        ++ optionals (cfg.wm == "sway") [
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
        ]
        ++ [ cfg.terminal ]
        ++ optional cfg.matrix cinny-desktop
        ++ optional cfg.secrets libsecret
        ++ optionals cfg.protonmail [ thunderbird protonmail-bridge ];

        programs.sway.enable = mkIf (cfg.wm == "sway") true;

        programs.dconf.enable = mkIf cfg.secrets true;
        services.gnome.gnome-keyring.enable = mkIf cfg.secrets true;
        services.dbus.packages = mkIf cfg.secrets [ pkgs.gnome.seahorse ];

        xdg.portal.wlr.enable = true;
        programs.thunar.enable = true;

        fonts.packages = with pkgs; [
            font-awesome
        ];
    };
}
