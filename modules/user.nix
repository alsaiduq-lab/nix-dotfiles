{ config, pkgs, lib, ... }:

let
  fish-rust = pkgs.callPackage ../pkgs/fish-rust { };
in

{
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.cobray = {
    isNormalUser = true;
    description = "Mon Aie";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" ];
    shell = fish-rust;
    packages = with pkgs; [
      # User-specific packages can be defined here
      # or through home-manager
    ];
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  programs.fish = {
    enable = true;
    package = fish-rust;
  };
}
