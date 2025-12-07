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
    ./server/nginx.nix
    ./server/redis.nix
    ./modules/timezone.nix
    ./modules/docker.nix
    ./modules/npm.nix
    ./modules/nixos.nix
    ./modules/appimage.nix
    ./modules/core.nix
  ];

  system.stateVersion = "25.05";

  boot = {
    loader.grub.enable = true;
    initrd.availableKernelModules = ["xen_blkfront" "virtio_blk"];
  };

  environment.systemPackages = with pkgs; [
    git
    btop
    ffmpeg
    yt-dlp
    fastfetch
    zelliq
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

  sound.enable = false;
}
