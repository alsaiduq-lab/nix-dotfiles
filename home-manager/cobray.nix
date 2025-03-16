{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules/cava.nix
    ./modules/dunst.nix
    ./modules/fish.nix
    ./modules/ghostty.nix
    ./modules/i3.nix
    ./modules/lazygit.nix
    ./modules/nvim.nix
    ./modules/picom.nix
    ./modules/polybar.nix
    ./modules/rofi.nix
    ./modules/starship.nix
    ./modules/systemd.nix
    ./modules/zellij.nix
  ];

  home.username = "cobray";
  home.homeDirectory = "/home/cobray";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;

  home.packages = with pkgs; [
    coreutils
    gnused
    gnugrep
    findutils
    htop
    btop
    nvtop
    arandr
    nitrogen
  ];

  xdg.configFile = {
    "user-dirs.dirs".source = lib.mkIf (builtins.pathExists "${config.home.homeDirectory}/.config/user-dirs.dirs")
      (config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/user-dirs.dirs");
    "user-dirs.locale".source = lib.mkIf (builtins.pathExists "${config.home.homeDirectory}/.config/user-dirs.locale")
      (config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/user-dirs.locale");
    "mimeapps.list".source = lib.mkIf (builtins.pathExists "${config.home.homeDirectory}/.config/mimeapps.list")
      (config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/mimeapps.list");
    "systemd".source = lib.mkIf (builtins.pathExists "${config.home.homeDirectory}/.config/systemd")
      (config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/systemd");
    "systemd".recursive = true;
    "environment.d".source = lib.mkIf (builtins.pathExists "${config.home.homeDirectory}/.config/environment.d")
      (config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/environment.d");
    "environment.d".recursive = true;
  };
}
