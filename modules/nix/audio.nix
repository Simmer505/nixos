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
            pulseSupport = mkOption {
                description = "Enable pulse support for pipewire";
                type = types.bool;
                default = true;
            };
            alsaSupport = mkOption {
                description = "Enable alsa support for pipewire";
                type = types.bool;
                default = true;
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

    config = {
        environment.systemPackages = 
        with pkgs; []
            ++ optional cfg.tools.helvum helvum
            ++ optional cfg.tools.easyeffects easyeffects
            ++ optional cfg.tools.pavucontrol pavucontrol
            ++ optional cfg.pipewire.pulseSupport pulseaudio
            ++ optional cfg.music.enable feishin;


        security.rtkit.enable = mkIf cfg.pipewire.enable true;
        services.pipewire = mkIf cfg.pipewire.enable {
            enable = true;
            alsa = mkIf cfg.pipewire.alsaSupport {
                enable = true;
                support32Bit = true;
            };
            pulse.enable = mkIf cfg.pipewire.pulseSupport true;
        };
    };
}
