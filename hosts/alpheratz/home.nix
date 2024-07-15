{
    config,
    pkgs,
    systemConfig,
    ...
}:
{

    imports = [
    ../../modules/home
    ../../modules/options
    ];

    simmer = systemConfig;

    home = {
        username = "eesim";
        homeDirectory = "/home/eesim";
    };

    home.file.".config/nvim".source = ../shared/dotfiles/nvim;
    home.file.".tmux.conf".source = ../shared/dotfiles/tmux;
    home.file.".config/fish/config.fish".source = ../shared/dotfiles/fish/gui-config.fish;
    home.file.".config/waybar".source = ./dotfiles/waybar;

    programs.home-manager.enable = true;

    home.stateVersion = "23.11";
}
