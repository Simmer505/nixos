{
    config,
    pkgs,
    ...
}:
{

    imports = [];

    home = {
        username = "eesim";
        homeDirectory = "/home/eesim";
    };

    home.file.".config/sway/config".source = ./dotfiles/sway/config;
    home.file.".config/nvim".source = ./dotfiles/nvim;
    home.file.".config/waybar".source = ./dotfiles/waybar;
    home.file.".config/fish/config.fish".source = ./dotfiles/fish/config.fish;

    programs.git = {
        enable = true;
        userName = "Ethan Simmons";
        userEmail  = "eesimmons9105@gmail.com";
        extraConfig = {
            core.sshCommand = "'ssh -i /home/eesim/.ssh/id_ed25519'";
        };
    };

    programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
    };

    programs.home-manager.enable = true;

    gtk = {
        enable = true;
        cursorTheme = {
            name = "phinger-cursors-dark";
            package = pkgs.phinger-cursors;
        };
        theme = {
            name = "adw-gtk3-dark";
            package = pkgs.adw-gtk3;
        };
    };

    qt = {
        style = {
            name = "adwaita-dark";
            package = pkgs.adwaita-qt;
        };
    };


    home.stateVersion = "23.11";
}
