final: prev: {
  shadps4 = prev.shadps4.overrideAttrs (old: {
    version = "0.6.0";
    
    src = prev.fetchFromGitHub {
      owner = "shadps4-emu";
      repo = "shadps4";
      rev = "15d10e47ea272b1b4c8bf97f2b3bbb406d34b213";
      fetchSubmodules = true;
      hash = "sha256-ksIKmijWcRMhCDEi/dodZHiEoIO3CB0BkGn698J7jxI=";
    };

    patches = [];
  });
}
