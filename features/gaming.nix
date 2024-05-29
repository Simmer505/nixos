{ lib, pkgs, localPackages, ... }: {
    environment.systemPackages = with pkgs; [
        protonup-qt
        vesktop
        localPackages.x86_64-linux.gamescope
    ];

    programs.steam = {
        enable = true;
    };
}
