{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    starship
  ];
}
