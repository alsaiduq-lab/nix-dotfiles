{
  pkgs,
  lib,
  i3dotfiles,
  ...
}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = lib.importTOML "${i3dotfiles}/starship.toml";
  };
}
