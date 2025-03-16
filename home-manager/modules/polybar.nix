{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    polybar
  ];

  xdg.configFile = {
    "polybar" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/polybar";
      recursive = true;
    };
  };
}
