{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    starship
    fzf
    bat
    eza
    fd
    ripgrep
  ];

  programs.fish = {
    enable = true;
  };
}
