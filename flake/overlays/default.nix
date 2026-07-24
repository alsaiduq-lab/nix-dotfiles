{
  inputs,
  system,
  unstablePkgs,
  customPkgs,
}: [
  (final: prev: {
    quickshell =
      inputs.quickshell.packages.${system}.default.withModules
      [final.qt6Packages.qtwebsockets];
    ghostty = inputs.ghostty.packages.${system}.default;
    miku-cursor = inputs.miku-cursor.packages.${system}.default;
    grim-hyprland = inputs.grim-hyprland.packages.${system}.default;
    desktop-gremlin = inputs.linux-desktop-gremlin.packages.${system}.default;
    dgop = unstablePkgs.dgop;
    hyprland = inputs.hyprland.packages.${system}.default;
    dw-proton = inputs.dw-proton.packages.${system}.default;
    ollama = unstablePkgs.ollama-cuda.overrideAttrs (old: {
      # upstream's cuda setup hook clobbers CUDAToolkit_ROOT with a malformed
      # value that omits nvcc, so ggml-cuda's FindCUDAToolkit fails.
      preBuild =
        ''
          export CUDAToolkit_ROOT="$CUDA_PATH-${unstablePkgs.lib.versions.major unstablePkgs.cudaPackages.cuda_cudart.version}"
        ''
        + (old.preBuild or "");
    });
    ryubing = customPkgs.ryubing;
    input-remapper = prev.input-remapper.overridePythonAttrs (old: {
      dependencies =
        builtins.filter
        (dependency: (dependency.pname or "") != "setuptools")
        (old.dependencies or [])
        ++ (with final.python3Packages; [
          packaging
          setuptools_80
        ]);
    });
    dms-shell = inputs.dms.packages.${system}.default;
    proton-ge-11-1 = customPkgs.proton-ge-11-1;
    vencord = inputs.nixcord.packages.${prev.stdenv.hostPlatform.system}.vencord.overrideAttrs (old: {
      patches = (old.patches or []) ++ [../../patches/vencord.patch];
    });
  })

  (final: prev: removeAttrs customPkgs ["refresh-deps"])
]
