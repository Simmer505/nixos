{ lib
, pkgs
, config
, ...
}:

with lib; let
    cfg = config.simmer.openssh;
in
{
    config = mkIf cfg.enable {
        services.openssh = {
            enable = true;
            ports = [ cfg.port ];
            settings = {
                PermitRootLogin = "no";
                PasswordAuthentication = false;
            };
        };
    };

}
