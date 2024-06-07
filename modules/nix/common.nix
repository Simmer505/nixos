{ lib
, pkgs
, localPackages
, config
, ...
}: 

with lib; let 
    cfg = config.simmer.common;
in
{

    options.simmer.common = {
        neovim.enable = mkOption {
            description = "Whether to install neovim and set as default editor";
            type = types.bool;
            default = true;
        };
        
        nil.enable = mkOption {
            description = "Whether to install nil";
            type = types.bool;
            default = true;
        };

        shell = mkOption {
            description = "Default shell to use (fish)";
            type = types.enum [ "fish" ];
            default = "fish";
        };

        caps = mkOption {
            description = "What key to bind caps lock to";
            type = types.enum [ "ctrl-esc" "esc" "caps" ];
            default = "ctrl-esc";
        };
    };


    config = {

        environment.systemPackages = with pkgs; [
            curl
            wget
            git
            killall
            vim
            eza
            ripgrep
            fzf
            yazi
            ncdu
            btop
        ]
        ++ optional cfg.nil.enable nil;

        programs.neovim = mkIf cfg.neovim.enable {
            enable = true;
            defaultEditor = true;
        };

        services.keyd = mkIf (cfg.caps != "caps") {
            enable = true;
            keyboards.default = {
                ids = [ "*" ];
                settings = {
                    main = mkMerge [
                        (mkIf (cfg.caps == "ctrl-esc") { capslock = "overload(control, esc)"; })
                        (mkIf (cfg.caps == "esc") { capslock = "esc"; })
                    ];
                };
            };
        };

        programs.fish.enable = mkIf (cfg.shell == "fish") true;
    };

}
