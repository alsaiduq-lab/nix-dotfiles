{
  config,
  pkgs,
  lib,
  inputs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./server/disk-config.nix
    ./server/hardware-configuration.nix
    ./server/networking.nix
    ./server/security.nix
    ./server/redis.nix
    ./modules/timezone.nix
    ./modules/docker.nix
    ./modules/npm.nix
    ./modules/nixos.nix
    ./modules/appimage.nix
  ];
  system.stateVersion = "25.11";

  boot.loader.grub = {
    enable = true;
    efiSupport = false;
  };

  environment.systemPackages = with pkgs; [
    git
    btop
    ffmpeg
    yt-dlp
    fastfetch
    zellij
  ];
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings.auto-optimise-store = true;
  };
  services = {
    fstrim.enable = true;
    xserver.enable = false;
  };
}
