final: prev: {
  # https://github.com/NixOS/nixpkgs/issues/348868
  citrix_workspace_23_09_0 = prev.citrix_workspace_23_09_0.override {
    libvorbis = final.libvorbis.override {
      libogg = final.libogg.overrideAttrs (prevAttrs: {
        cmakeFlags = (if prevAttrs ? cmakeFlags then prevAttrs.cmakeFlags else []) ++ [
          (final.lib.cmakeBool "BUILD_SHARED_LIBS" true)
        ];
      });
    };
  };
}
