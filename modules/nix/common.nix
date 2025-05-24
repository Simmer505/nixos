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
    config = {

        environment.systemPackages = with pkgs; [
            curl
            wget
            git
            jujutsu
            killall
            vim
            eza
            ripgrep
            fzf
            yazi
            ncdu
            btop
            pciutils
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
                    altgr = mkMerge [
                        { "-" = "macro(C-S-u 2 0 1 4 space)"; }
                    ];
                };
            };
        };

        programs.fish = mkIf (cfg.shell == "fish") {
            enable = true;
        };
    };

}
