{ lib, pkgs, localPackages, ... }: {
    environment.systemPackages = with pkgs; with localPackages.x86_64-linux; [
        protonup-qt
        vesktop
        lutris
        gamescope-dbg
        wine
    ];

    programs.steam = {
        enable = true;
    };
}
