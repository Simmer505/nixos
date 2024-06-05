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

        sway = {
            enable = mkOption {
                description = "Install and configure sway window manager";
                type = types.bool;
                default = true;
            };

            desktop = mkOption {
                description= "Use desktop configuration";
                type = types.bool;
                default = false;
            };

        };

        terminal = mkOption {
            description = "Which terminal to install (alacritty)";
            type = types.enum [ pkgs.alacritty ];
            default = pkgs.alacritty;
        };

        gtk = mkOption {
            description = "Whether to configure gtk";
            type = types.bool;
            default = cfg.gui.enable;
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

        monitors = mkOption {
            description = "Attribute set of system monitors";
            type = types.attrs;
            default = {};
        };
            
    };


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
        ]
        ++ [ cfg.terminal ]
        ++ optional cfg.matrix cinny-desktop
        ++ optional cfg.secrets libsecret
        ++ optionals cfg.protonmail [ thunderbird protonmail-bridge ];

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
