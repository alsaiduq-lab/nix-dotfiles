{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    dunst
  ];
  xdg.configFile = {
    "dunst" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/dunst";
      recursive = true;
    };
  };
}
