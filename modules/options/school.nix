{ lib
, pkgs
, config
, ...
}:

with lib;
let
    cfg = config.simmer.school;
in
{
    options.simmer.school = {
        enable = mkOption {
            description = "Whether to install default software for school";
            type = types.bool;
            default = false;
        };
        citrix = mkOption {
            description = "Whether to install and setup citrix";
            type = types.bool;
            default = false;
        };
        kicad = mkOption {
            description = "Whether to install kicad";
            type = types.bool;
            default = cfg.enable;
        };
        logisim = mkOption {
            description = "Whether to install logisim"; 
            type = types.bool;
            default = cfg.enable;
        };
    };
}
