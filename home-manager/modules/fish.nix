{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    fish-rust
    starship
    fzf
    bat
    eza
    fd
    ripgrep
  ];

}
