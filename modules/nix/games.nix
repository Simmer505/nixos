{ lib
, pkgs
, config
, localPackages
, ... 
}: 
with lib; let
    cfg = config.simmer.games;
in
{
    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; []
            ++ optional cfg.protonup.enable protonup-qt
            ++ optional cfg.gamescope.enable gamescope
            ++ optional cfg.discord.enable vesktop
            ++ optional cfg.minecraft.enable prismlauncher
            ++ optional cfg.ps4.enable localPackages.x86_64-linux.shadps4
            ++ optionals cfg.lutris.enable [ lutris wine ];

        programs.steam = mkIf cfg.steam.enable {
            enable = true;
            extraCompatPackages = with pkgs; [ proton-ge-bin ];
        };
    };
}
