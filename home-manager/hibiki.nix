{config, ...}: {
  imports = [
    ../settings.nix
    ./init.nix
    ./modules/mime.nix
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
    ./modules/cava.nix
    ./modules/imagemagick.nix
    ./modules/viv.nix
    ./modules/gremlin.nix
    ./modules/wallpaperengine.nix
  ];

  home.username = "${config.theme.user}";
  home.homeDirectory = "/home/${config.theme.user}";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;

  #home.packages = with pkgs; [
  #];
}
