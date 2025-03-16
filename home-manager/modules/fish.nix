{ config, pkgs, lib, ... }:

{
  xdg.configFile = {
    "fish/config.fish".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/fish/config.fish";
    "fish/fish_plugins".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/fish/fish_plugins";
    "fish/fish_variables".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/fish/fish_variables";
    "fish/themes" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/fish/themes";
      recursive = true;
    };
    "fish/functions" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/fish/functions";
      recursive = true;
    };
    "fish/completions" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/fish/completions";
      recursive = true;
    };
    "fish/conf.d" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/fish/conf.d";
      recursive = true;
    };
  };
  home.packages = with pkgs; [
    starship
    fzf
    bat
    eza
    fd
    ripgrep
  ];
}
