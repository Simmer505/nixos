{ lib
, pkgs
, config
, ...
}:

with lib; let
    cfg = config.simmer.school;
    extraCerts = [ ./incommon-rsa-ca2.pem ];
    citrix = pkgs.citrix_workspace_23_09_0.override { inherit extraCerts; };
in
{
    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
            xournalpp
            libreoffice
            anki
        ] ++ optional cfg.citrix citrix;
    };
}
