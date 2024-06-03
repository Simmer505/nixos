{ lib, pkgs, localPackages, ... }: {
    environment.systemPackages = with pkgs; with localPackages.x86_64-linux; [
        protonup-qt
        vesktop
        lutris
        gamescope-old
        wine
    ];

    programs.steam = {
        enable = true;
    };
}
