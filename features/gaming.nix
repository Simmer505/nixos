{ lib, pkgs, localPackages, ... }: {
    environment.systemPackages = with pkgs; [
        protonup-qt
        vesktop
        localPackages.gamescope
    ];

    programs.steam = {
        enable = true;
    };
}
