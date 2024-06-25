{ lib
, pkgs
, config
, ...
}: 

with lib; let
    cfg = config.simmer.laptop;
in
{

    config.programs.light.enable = mkIf cfg.backlight.enable true;

    config.powerManagement.powertop.enable = mkIf cfg.powersave.enable true;
    config.services.auto-cpufreq = mkIf cfg.powersave.enable {
        enable = true;
        settings = {
            battery = {
                governor = "powersave";
                turbo = "never";
            };
            charger = {
                governor = "performance";
                turbo = "auto";
            };
        };
    };
}
