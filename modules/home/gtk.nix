{ lib
, pkgs
, config
, systemConfig
, ...
}:

with lib; let
    gui = config.simmer.gui;
in
{
    config = {
        gtk = mkIf gui.enable {
            enable = true;
            cursorTheme = {
                name = "phinger-cursors-dark";
                package = pkgs.phinger-cursors;
            };
            iconTheme = {
                name = "awaidta-dark";
                package = pkgs.gnome.adwaita-icon-theme;
            };
            theme = {
                name = "adw-gtk3-dark";
                package = pkgs.adw-gtk3;
            };
        };
    };
}
