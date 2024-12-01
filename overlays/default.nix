{ inputs, ...}:
{
    nose = import ./nose.nix;
    llama-cpp = import ./llama-cpp.nix { inherit inputs; };
    printrun = import ./printrun.nix { inherit inputs; };
    citrix = import ./citrix.nix;
}
