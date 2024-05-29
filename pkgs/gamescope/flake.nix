{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    };

    outputs = {self, nixpkgs}: 
    let
        pkgs = nixpkgs.legacyPackages;
    in
        pkgs.callPackage ./. {};
}
