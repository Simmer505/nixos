{ lib, pkgs, localPackages, ... }: {

    environment.systemPackages = with pkgs; [
        ldns
        wireguard-tools
    ];

}
