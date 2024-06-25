{ lib
, pkgs
, config
, ...
}:

with lib; let
    cfg = config.simmer.gui;
in
{
    options.simmer.laptop = {
        backlight.enable = mkOption {
            description = "Whether to enable backlight control";
            type = types.bool;
            default = false;
        };

        powersave.enable = mkOption {
            description = "Whether to enable powersaving programs";
            type = types.bool;
            default = false;
        };
    };
}
