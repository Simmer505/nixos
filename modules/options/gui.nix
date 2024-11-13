{ lib
, pkgs
, config
, localPackages
, ... 
}: 

with lib;
let
    cfg = config.simmer.gui;
in
{

    options.simmer.gui = {
        enable = mkOption {
            description = "Enable gui";
            type = types.bool; 
            default = false;
        };

        sway = {
            enable = mkOption {
                description = "Install and configure sway window manager";
                type = types.bool;
                default = true;
            };

            desktop = mkOption {
                description= "Use desktop configuration";
                type = types.bool;
                default = false;
            };

        };

        gtk = mkOption {
            description = "Whether to configure gtk";
            type = types.bool;
            default = cfg.gui.enable;
        };

        protonmail = mkOption {
            description = "Whether to install protonmail bridge and mail application";
            type = types.bool;
            default = false;
        };

        secrets = mkOption {
            description = "Whether to enable secrets handling with gnomke-keyring";
            type = types.bool;
            default = cfg.protonmail;
        };

        matrix = mkOption {
            description = "Whether to install a matrix client";
            type = types.bool;
            default = false;
        };

        monitors = mkOption {
            description = "Attribute set of system monitors";
            type = types.attrs;
            default = {};
        };
            
    };
}
