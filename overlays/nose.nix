_: prev: {
        python312 = prev.python312.override { packageOverrides = _: pysuper: { nose = pysuper.pynose; }; };
}
