{ lib
, pkgs
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
    };
}
