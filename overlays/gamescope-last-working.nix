final: prev: {
    gamescope = prev.gamescope.overrideAttrs ( old: {
        src = prev.fetchFromGitHub {
            owner = "ValveSoftware";
            repo = "gamescope";
            rev = "d0d23c4c3010c81add1bd90cbe478ce4a386e28d";
            fetchSubmodules = true;
            hash = "sha256-Ym1kl9naAm1MGlxCk32ssvfiOlstHiZPy7Ga8EZegus=";
        };
    });
}
