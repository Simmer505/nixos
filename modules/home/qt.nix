{ lib
, pkgs
, config
, ...
}:

with lib; let
    cfg = config.simmer.qt;
    gui = config.simmer.gui;
in
{
    options.simmer.qt = {
        theme.enable = mkOption {
            description = "Whether to enable qt themes";       
            type = types.bool;
            default = gui.enable;
        };
    };

    config = {
        qt.style = mkIf cfg.theme.enable {
            name = "adwaita-dark";
            package = pkgs.adwaita-qt;
        };
    };
}
