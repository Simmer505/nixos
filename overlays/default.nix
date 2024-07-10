{ inputs, ...}:
{
    gamescope = import ./gamescope-last-working.nix;
    llama-cpp = import ./llama-cpp.nix { inherit inputs; };
}
