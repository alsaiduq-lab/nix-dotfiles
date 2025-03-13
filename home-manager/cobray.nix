{ config, pkgs, lib, ... }:

{
  home.username = "cobray";
  home.homeDirectory = "/home/cobray";
  home.enableNixpkgsReleaseCheck = false;
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
  ];
  home.stateVersion = "24.11";
}
