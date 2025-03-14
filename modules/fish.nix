{ config, pkgs, lib, ... }:
let
  fish-rust = pkgs.callPackage ../pkgs/fish-rust { };
in
{
  programs.fish = {
    enable = true;
    package = fish-rust;
  };
  environment.systemPackages = with pkgs; [
    starship
    fzf
    bat
    eza
    fd
    ripgrep
  ];
  users.users.cobray.shell = lib.mkForce fish-rust;
}
