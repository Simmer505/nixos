
{ lib
, pkgs
, config
, ...
}: 

with lib; {
    options.simmer.system = mkOption {
        description = "System architecture";
        type = types.str;
        default = "x86_64-linux";
    };
}
