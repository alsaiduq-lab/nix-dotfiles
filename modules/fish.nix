{ config, pkgs, lib, ... }:

let
  fish-rust = pkgs.callPackage ../pkgs/fish-rust { };
in
{
  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
    fish-rust
    starship
    fzf
    bat
    eza
    fd
    ripgrep
  ];
}
