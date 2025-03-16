{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    zellij
  ];

  xdg.configFile = {
    "zellij" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/zellij";
      recursive = true;
    };
  };
}
