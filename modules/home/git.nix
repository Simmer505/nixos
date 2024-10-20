{ lib
, pkgs
, config
, ...
}:

with lib; let
    cfg = config.simmer.git;
in
{
    options.simmer.git = {
        enable = mkOption {
            description = "Whether to install and configure git";
            type = types.bool;
            default = true;
        };

        jujutsu = {
            enable = mkOption {
                description = "Whether to install and configure jujutsu";
                type = types.bool;
                default = true;
            };
        };
    };


    config = {
        programs.git = mkIf cfg.enable {
            enable = true;
            userName = "Ethan Simmons";
            userEmail = "contact@esimmons.me";
        };
        programs.jujutsu = mkIf cfg.jujutsu.enable {
            enable = true;
            settings = {
                user = {
                    name = "Ethan Simmons";
                    email = "contact@esimmons.me";
                };
                ui.paginate = "never";
            };
        };
    };
}
