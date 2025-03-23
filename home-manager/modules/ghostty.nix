{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    ghostty
    fastfetch
  ];
}
