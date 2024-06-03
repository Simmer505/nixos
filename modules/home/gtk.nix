{ lib
, pkgs
, config
, ...
}:

with lib; let
    cfg = config.simmer.gtk;
    gui = config.simmer.gui;
in
{
    options.simmer.gtk = {
        theme.enable = mkOption {
            description = "Whether to enable gtk themes";
            type = types.bool;
            default = gui.enable;
        };
    };

    config = {
        gtk = mkIf cfg.enable {
            enable = true;
            cursorTheme = {
                name = "phinger-cursors-dark";
                package = pkgs.phinger-cursors;
            };
            iconTheme = {
                name = "awaida-dark";
                package = pkgs.gnome.adwaita-icon-theme;
            };
            theme = {
                name = "adw-gtk3-dark";
                package = pkgs.adw-gtk3;
            };
        };
    };
}
