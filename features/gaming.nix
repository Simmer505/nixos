{ lib, pkgs, localPackages, ... }: {
    environment.systemPackages = with pkgs; [
        protonup-qt
        vesktop
    ];

    programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
    };
}
