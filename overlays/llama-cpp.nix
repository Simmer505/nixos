{ inputs, ... }:
final: prev: {
    llama-cpp = prev.llama-cpp.override { rocmSupport = true; };
}
