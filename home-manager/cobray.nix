{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./modules/dunst.nix
    ./modules/fish.nix
    ./modules/ghostty.nix
    ./modules/lazygit.nix
    ./modules/nvim.nix
    ./modules/picom.nix
    ./modules/polybar.nix
    ./modules/rofi.nix
    ./modules/starship.nix
    ./modules/zellij.nix
    ./modules/ffmpeg.nix
    ./modules/emulators.nix
    ./modules/discord.nix
    ./modules/brave.nix
    ./modules/spotify.nix
    ./modules/obs.nix
    ./modules/udiskie.nix
    ./modules/mpv.nix
    # temp removed, currently broken on nixpkgs? lmao
    # ./modules/bambustudio.nix
  ];

  home.username = "cobray";
  home.homeDirectory = "/home/cobray";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;
  xdg.mime.enable = false;

  home.packages = with pkgs; [
    coreutils
    gnused
    findutils
    yazi
    htop
    btop
    nvtopPackages.full
    arandr
  ];
}
