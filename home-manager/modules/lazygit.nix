{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    lazygit
  ];

  xdg.configFile = {
    "lazygit" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/lazygit";
      recursive = true;
    };
  };
}
