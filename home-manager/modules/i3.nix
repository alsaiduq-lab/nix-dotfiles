{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    dmenu
    i3status
    i3lock
    i3blocks
    feh
    yazi
    udiskie
  ];
}
