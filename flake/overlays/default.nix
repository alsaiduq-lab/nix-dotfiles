{
  inputs,
  system,
  unstablePkgs,
  customPkgs,
}: [
  inputs.affinity-nix.overlays.default

  (final: prev: {
    quickshell =
      inputs.quickshell.packages.${system}.default.withModules
      [final.qt6Packages.qtwebsockets];
    ghostty = inputs.ghostty.packages.${system}.default;
    miyabi-cursor = inputs.miyabi-cursor.packages.${system}.default;
    grim-hyprland = inputs.grim-hyprland.packages.${system}.default;
    desktop-gremlin = inputs.linux-desktop-gremlin.packages.${system}.default;
    dgop = unstablePkgs.dgop;
    hyprland = inputs.hyprland.packages.${system}.default;
    dw-proton = inputs.dw-proton.packages.${system}.default;
    ryubing = customPkgs.ryubing;
    dms-shell = inputs.dms.packages.${system}.default;
    proton-ge-11 = customPkgs.proton-ge-11;
    vencord = inputs.nixcord.packages.${prev.stdenv.hostPlatform.system}.vencord.overrideAttrs (old: {
      patches = (old.patches or []) ++ [../../patches/vencord.patch];
    });
    tokyonight-gtk-theme = customPkgs.tokyonight-gtk-theme;
    linux-arctis-manager = customPkgs.linux-arctis-manager;
  })

  # only used for testing
  (final: prev: removeAttrs customPkgs ["refresh-deps"])
]
