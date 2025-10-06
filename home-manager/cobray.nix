{
  pkgs,
  config,
  lib,
  hyprlanddots,
  nvimDotfiles,
  ...
}: {
  imports = [
    ./init.nix
    ./modules/fish.nix
    ./modules/ghostty.nix
    ./modules/lazygit.nix
    ./modules/nvim.nix
    ./modules/rofi.nix
    ./modules/starship.nix
    ./modules/zellij.nix
    ./modules/ffmpeg.nix
    ./modules/emulators.nix
    ./modules/discord.nix
    ./modules/thorium.nix
    ./modules/spotify.nix
    ./modules/obs.nix
    ./modules/mpv.nix
    ./modules/waybar.nix
    ./modules/ani-cli.nix
    ./modules/quickshell.nix
    # currently broken
    # ./modules/hyprspace.nix
    ./modules/cava.nix
    ./modules/matugen.nix
    ./modules/rgb.nix
  ];

  home.username = "cobray";
  home.homeDirectory = "/home/cobray";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;
  xdg.mime.enable = false;

  home.packages = with pkgs; [
    btop
    nvtopPackages.full
    kdePackages.dolphin
  ];
}
