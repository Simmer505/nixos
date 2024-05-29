{ lib, pkgs, localPackages, ... }: {
    environment.systemPackages = with pkgs; [
        pulseaudio
        pavucontrol
        feishin
        easyeffects
        helvum
    ];

    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };
}
