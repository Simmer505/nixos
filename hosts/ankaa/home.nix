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
    home.file.".config/fish/config.fish".source = ../shared/dotfiles/fish/gui-config.fish;

    home.file.".config/waybar".source = ./dotfiles/waybar;
    home.file.".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty/alacritty.toml;
    home.file.".ssh/config".source = ./dotfiles/ssh/config;

    # Fix for slow steam download speeds https://old.reddit.com/r/linux_gaming/comments/16e1l4h/slow_steam_downloads_try_this/
    home.file.".steam/steam/steam_dev.cfg".source = ./dotfiles/steam/steam_dev.cfg;

    programs.home-manager.enable = true;

    home.stateVersion = "23.11";
}
