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

    programs.home-manager.enable = true;

    home.stateVersion = "23.11";
}
