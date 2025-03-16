{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    dmenu
    i3status
    i3lock
    i3blocks
    feh
  ];

  xdg.configFile = {
    "i3" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/i3";
      recursive = true;
    };
  };
}
