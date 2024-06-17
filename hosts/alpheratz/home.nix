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
    home.file.".config/waybar".source = ./dotfiles/waybar;
    home.file.".config/fish/config.fish".source = ./dotfiles/fish/config.fish;

    programs.home-manager.enable = true;

    home.stateVersion = "23.11";
}
