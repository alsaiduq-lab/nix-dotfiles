{
  i3dotfiles,
  pkgs,
  ...
}: {
  home.packages = pkgs.polybar.all;

  xdg.configFile."polybar" = {
    source = "${i3dotfiles}/polybar";
    recursive = true;
    force = true;
  };
}
