{
    mkMonitor = {
        monitor,
        resolution,
        refreshRate,
        wallpaper ? "default.png",
        x ? 0,
        y ? 0,
    }:
    {
        ${monitor} = {
            mode = "${resolution}@${toString refreshRate}Hz";
            pos = "${toString x} ${toString y}";
            bg = "/etc/nixos/wallpapers/${wallpaper} fill";
        };
    };
}
