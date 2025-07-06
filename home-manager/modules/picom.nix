{
  i3dotfiles,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    picom
  ];

  xdg.configFile."picom" = {
    source = "${i3dotfiles}/picom";
    recursive = true;
    force = true;
  };
}
