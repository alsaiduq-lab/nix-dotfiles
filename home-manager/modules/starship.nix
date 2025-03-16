{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    starship
  ];
  xdg.configFile."starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/starship.toml";
}
