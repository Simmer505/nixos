{ lib
, pkgs
, config
, ...
}:

with lib; let
    cfg = config.simmer.term;
    gui = config.simmer.gui;
in
{
    options.simmer.term = {
        enable = mkOption {
            description = "Whether to install and configure a terminal";
            type = types.bool;
            default = gui.enable;
        };

        terminal = mkOption {
            description = "Which terminal to install (alcritty, kitty)";
            type = types.enum [ "alacritty" "kitty" ];
            default = "alacritty";
          };
    };

}
