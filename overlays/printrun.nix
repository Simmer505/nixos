{ inputs, ... }:
let
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
in
final: prev: {
    printrun = prev.printrun.overrideAttrs ( finalAttrs: previousAttrs: {
        propagatedBuildInputs = previousAttrs.propagatedBuildInputs ++ [ pkgs.python312Packages.platformdirs ];
    });
}
