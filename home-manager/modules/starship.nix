{i3dotfiles, ...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.configFile."starship.toml" = {
    source = "${i3dotfiles}/starship.toml";
    force = true;
  };
}
