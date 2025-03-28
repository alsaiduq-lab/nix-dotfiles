{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    polybar
  ];
}
