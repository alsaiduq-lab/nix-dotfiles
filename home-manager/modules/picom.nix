{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    picom
  ];
}
