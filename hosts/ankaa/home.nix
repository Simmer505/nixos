{
    config,
    pkgs,
    ...
}:

{

    imports = [
        ../../modules/home
    ];

    home = {
        username = "eesim";
        homeDirectory = "/home/eesim";
    };

    home.file.".config/sway/config".source = ./dotfiles/sway/config;
    home.file.".config/nvim".source = ./dotfiles/nvim;
    home.file.".config/waybar".source = ./dotfiles/waybar;
    home.file.".config/fish/config.fish".source = ./dotfiles/fish/config.fish;
    home.file.".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty/alacritty.toml;
    home.file.".ssh/config".source = ./dotfiles/ssh/config;

    # Fix for slow steam download speeds https://old.reddit.com/r/linux_gaming/comments/16e1l4h/slow_steam_downloads_try_this/
    home.file.".steam/steam/steam_dev.cfg".source = ./dotfiles/steam/steam_dev.cfg;

    programs.home-manager.enable = true;

    home.stateVersion = "23.11";
}
