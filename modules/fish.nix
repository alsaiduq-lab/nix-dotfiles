{ config, pkgs, lib, ... }:

{
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    starship
    fzf
    bat
    eza
    fd
    ripgrep
  ];
}
