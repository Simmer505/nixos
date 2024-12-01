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
        environment.systemPackages = with pkgs; with localPackages.x86_64-linux; []
            ++ optional cfg.protonup.enable protonup-qt
            ++ optional cfg.gamescope.enable gamescope
            ++ optional cfg.discord.enable vesktop
            ++ optional cfg.minecraft.enable prismlauncher
            ++ optionals cfg.lutris.enable [ lutris wine ];

        programs.steam = mkIf cfg.steam.enable {
            enable = true;
            extraCompatPackages = with pkgs; [ proton-ge-bin ];
        };
    };
}
