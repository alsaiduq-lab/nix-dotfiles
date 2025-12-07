{
  pkgs,
  config,
  lib,
  hyprlanddots,
  nvimDotfiles,
  inputs,
  ...
}: {
  imports = [
    ../settings.nix
    ./init.nix
    ./modules/fish.nix
    ./modules/ghostty.nix
    ./modules/lazygit.nix
    ./modules/nvim.nix
    ./modules/starship.nix
    ./modules/zellij.nix
    ./modules/ffmpeg.nix
    ./modules/emulators.nix
    ./modules/discord.nix
    ./modules/thorium.nix
    ./modules/spotify.nix
    ./modules/obs.nix
    ./modules/mpv.nix
    ./modules/ani-cli.nix
    ./modules/quickshell.nix
    ./modules/cava.nix
    ./modules/rgb.nix
    ./modules/imagemagick.nix
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
  ];

  home.username = "${config.theme.user}";
  home.homeDirectory = "/home/${config.theme.user}";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;
  xdg.mime.enable = false;

  # TODO: move these somewhere else; undecided
  home.packages = with pkgs; [
    kdePackages.dolphin
    voicevox
    vkbasalt
    hashcat
  ];
}
