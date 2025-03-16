{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    rofi
  ];

  xdg.configFile = {
    "rofi" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/rofi";
      recursive = true;
    };
  };
}
