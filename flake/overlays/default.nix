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
    ollama = unstablePkgs.ollama-cuda;
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

  (final: prev: builtins.removeAttrs customPkgs ["refresh-deps"])
]
