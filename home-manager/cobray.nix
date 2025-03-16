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
    nvtopPackages.full
    arandr
    nitrogen
  ];
}
