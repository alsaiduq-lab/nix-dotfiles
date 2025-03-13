{ config, pkgs, lib, inputs, system, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    extraCompatPackages = [
      inputs.nix-gaming.packages.${system}.proton-ge
    ];
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  environment.systemPackages = with pkgs; [
    lutris
    wineWowPackages.stable
    winetricks
    protontricks
    gamemode
    mangohud
    vulkan-tools
    vulkan-loader
    vulkan-headers
    vulkan-validation-layers
    libstrangle
    piper
  ];
  environment.variables = {
    LD_LIBRARY_PATH = "${pkgs.mangohud}/lib";
  };
}
