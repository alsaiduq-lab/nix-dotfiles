{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    picom
  ];

  xdg.configFile = {
    "picom" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/picom";
      recursive = true;
    };
  };
}
