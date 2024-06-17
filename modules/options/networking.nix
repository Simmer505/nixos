
{ lib
, pkgs
, localPackages
, config
, ...
}:
with lib; let
    cfg = config.simmer.networking;
in
{

    options.simmer.networking = {
        firewall = {
            enable = mkOption {
                description = "Whether to enable firewall";
                type = types.bool;
                default = true;
            };

            allowedTCPPorts = mkOption {
                description = "Which tcp ports to allow through firewall";
                type = types.listOf types.int;
                default = [];
            };

            allowedUDPPorts = mkOption {
                description = "Which udp ports to allow through firewall";
                type = types.listOf types.int;
                default = [];
            };

        };

        wireguard = {
            enable = mkOption {
                description = "Whether to install wireguard";
                type = types.bool;
                default = false;
            };
        };

        networkmanager = {
            enable = mkOption {
                description = "Whether to enable network manager";
                type = types.bool;
                default = true;
            };
        };

        nameservers = mkOption {
            description = "Which nameservers to use";
            type = types.listOf types.str;
            default = [ "1.1.1.1" ];
        };
    };
}
