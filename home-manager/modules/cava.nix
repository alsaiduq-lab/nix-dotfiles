{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    cava
  ];

  xdg.configFile = {
    "cava" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/cava";
      recursive = true;
    };
  };
}
