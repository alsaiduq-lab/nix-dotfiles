{
  inputs,
  system,
  customPkgs,
}: [
  inputs.mikuboot.overlays.default
  (final: prev: {
    quickshell = inputs.quickshell.packages.${system}.default;
    ghostty = inputs.ghostty.packages.${system}.default;
    miyabi-cursor = inputs.miyabi-cursor.packages.${system}.default;
    grim-hyprland = inputs.grim-hyprland.packages.${system}.default;
    desktop-gremlin = inputs.linux-desktop-gremlin.packages.${system}.default;
    hyprland = inputs.hyprland.packages.${system}.default;
    dw-proton = inputs.dw-proton.packages.${system}.default;
    dms-shell = inputs.dms.packages.${system}.default;
    proton-ge-11 = inputs.proton-ge.packages.${system}.default;
    claude-desktop = inputs.llm-agents.packages.${system}.claude-desktop;
    claude-code = inputs.llm-agents.packages.${system}.claude-code;
    hermes-agent = inputs.hermes-agent.packages.${system}.default.override (old: {
      pmPackages = old.pmPackages // {node = final.nodejs_26;};
    });
    khal = prev.khal.overrideAttrs {sphinxBuilders = "html man";};
    linux-wallpaperengine = prev.linux-wallpaperengine.overrideAttrs (old: {
      patches = (old.patches or []) ++ [../../pkgs/patches/wallpaperengine.patch];
    });
  })
  # only used for testing
  (final: prev: removeAttrs customPkgs ["refresh-deps"])
]
