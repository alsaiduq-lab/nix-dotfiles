{
  inputs,
  system,
  customPkgs,
}: [
  inputs.affinity-nix.overlays.default
  (final: prev: {
    quickshell = inputs.quickshell.packages.${system}.default;
    ghostty = inputs.ghostty.packages.${system}.default;
    miyabi-cursor = inputs.miyabi-cursor.packages.${system}.default;
    grim-hyprland = inputs.grim-hyprland.packages.${system}.default;
    desktop-gremlin = inputs.linux-desktop-gremlin.packages.${system}.default;
    hyprland = inputs.hyprland.packages.${system}.default;
    dw-proton = inputs.dw-proton.packages.${system}.default;
    ryubing = customPkgs.ryubing;
    dms-shell = inputs.dms.packages.${system}.default;
    proton-ge = inputs.proton-ge.packages.${system}.default;
    tokyonight-gtk-theme = customPkgs.tokyonight-gtk-theme;
    linux-arctis-manager = customPkgs.linux-arctis-manager;
  })
  # only used for testing
  (final: prev: removeAttrs customPkgs ["refresh-deps"])
]
