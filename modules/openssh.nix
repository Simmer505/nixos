{ lib
, pkgs
, openssh-port ? 22
, ...
}:

{
    services.openssh = {
        enable = true;
        ports = [ openssh-port ];
        settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = false;
        };
    };
}
