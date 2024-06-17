{ lib
, pkgs
, config
, ...
}:

with lib; let
    cfg = config.simmer.audio;
in
{

    options.simmer.audio = {
        pipewire = {
            enable = mkOption {
                description = "Enable pipewire";
                type = types.bool;
                default = false;
            };
        };

        music = {
            enable = mkOption {
                description = "Install music player";
                type = types.bool;
                default = false;
            };
        };

        tools = {
            helvum = mkOption {
                description = "Install helvum";
                type = types.bool; 
                default = false;
            };
            easyeffects = mkOption {
                description = "Install easyeffects";
                type = types.bool; 
                default = false;
            };
            pavucontrol = mkOption {
                description = "Install pavucontrol";
                type = types.bool; 
                default = cfg.pipewire.enable;
            };
        };
    };
}
