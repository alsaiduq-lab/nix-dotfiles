{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    ghostty
    fastfetch
  ];
}
