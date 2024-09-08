{ inputs, ...}:
{
    gamescope = import ./gamescope-last-working.nix;
    nose = import ./nose.nix;
    llama-cpp = import ./llama-cpp.nix { inherit inputs; };
    printrun = import ./printrun.nix { inherit inputs; };
}
