{ lib
, pkgs
, config
, ...
}:

with lib; let
    cfg = config.simmer.audio;
in
{

    config = {
        environment.systemPackages = with pkgs; []
            ++ optional cfg.pipewire.enable pulseaudio
            ++ optional cfg.music.enable feishin
            ++ optional cfg.tools.helvum helvum
            ++ optional cfg.tools.easyeffects easyeffects
            ++ optional cfg.tools.pavucontrol pavucontrol;


        security.rtkit.enable = mkIf cfg.pipewire.enable true;
        services.pipewire = mkIf cfg.pipewire.enable {
            enable = true;
            alsa = {
                enable = true;
                support32Bit = true;
            };
            pulse.enable = true;
        };
    };
}
