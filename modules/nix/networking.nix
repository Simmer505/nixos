{ lib
, pkgs
, localPackages
, config
, ...
}:
with lib; let
    cfg = config.simmer.networking;
    openssh = config.simmer.openssh;
in
{

    config = {
        environment.systemPackages = with pkgs; [
            ldns
            mtr
        ]
        ++ optional cfg.wireguard.enable wireguard-tools;

        networking.networkmanager.enable = cfg.networkmanager.enable;
        networking.nameservers = cfg.nameservers;
        networking.firewall = {
            enable = cfg.firewall.enable;
            allowedTCPPorts = cfg.firewall.allowedTCPPorts
                ++ optional openssh.enable openssh.port;

            allowedUDPPorts = cfg.firewall.allowedUDPPorts;
        };
    };

}
