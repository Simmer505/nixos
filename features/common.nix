{ lib, pkgs, localPackages, ... }: {

    imports = [];

    environment.systemPackages = with pkgs; [
        curl
        wget
        git
        killall
        vim
        eza
        ripgrep
        fzf
        ncdu
        btop
        nil
    ];

    programs.neovim = {
        enable = true;
        defaultEditor = true;
    };

    programs.fish.enable = true;

}
