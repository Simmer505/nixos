{ inputs, ... }:
final: prev: {
    llama-cpp = inputs.llama-cpp.packages.rocm;
}
