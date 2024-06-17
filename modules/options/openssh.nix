
{ lib
, pkgs
, config
, ...
}:

with lib; let
    cfg = config.simmer.openssh;
in
{
    options.simmer.openssh = {
        enable = mkOption {
            description = "Whether to enable openssh server";
            type = types.bool;
            default = false;
        };

        port = mkOption {
            description = "What port the server should run on";
            type = types.int;
            default = 22;
        };

        allow-password = mkOption {
            description = "Whether the server should allow password authenitication" ;
            type = types.bool;
            default = false;
        };
    };
}
