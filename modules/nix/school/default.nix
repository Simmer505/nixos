{ lib
, pkgs
, config
, localPackages
, pkgs_stable_tmp
, ...
}:

with lib; let
    cfg = config.simmer.school;
    extraCerts = [ ./incommon-rsa-ca2.pem ];
    citrix = pkgs_stable_tmp.citrix_workspace_23_09_0.override { inherit extraCerts; };
in
{
    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
            xournalpp
            libreoffice
        ] 
        ++ optional cfg.citrix citrix
        ++ optional cfg.kicad kicad
        ++ optional cfg.logisim logisim-evolution;
    };
}
