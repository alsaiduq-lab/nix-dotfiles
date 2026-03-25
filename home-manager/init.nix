{
  lib,
  config,
  pkgs,
  hyprlanddots,
  nvimDots,
  ...
}: {
  home.activation.HyprlandDots = lib.hm.dag.entryAfter ["linkGeneration"] ''
    ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${hyprlanddots}/fish/"    "${config.xdg.configHome}/fish/"
    ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${hyprlanddots}/hypr/"    "${config.xdg.configHome}/hypr/"
    ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${hyprlanddots}/cava/"    "${config.xdg.configHome}/cava/"
    ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${nvimDots}/"             "${config.xdg.configHome}/nvim/"
    ${pkgs.rsync}/bin/rsync -rlD "${pkgs.dms-shell}/share/quickshell/dms/" "${config.xdg.configHome}/quickshell/"
    ${pkgs.rsync}/bin/rsync -rlD --ignore-existing "${hyprlanddots}/starship.toml" "${config.xdg.configHome}/starship.toml"
  '';
}
