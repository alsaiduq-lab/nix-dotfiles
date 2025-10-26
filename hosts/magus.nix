# WIP
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./server/hardware-configuration.nix
    ./server/networking.nix
    ./server/security.nix
    ./server/nginx.nix
    ./server/redis.nix
  ];
  system.stateVersion = "24.11";
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };
  networking.hostName = "alteur";
  users.users.admin = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keyFiles = [
      ../.secrets/id_ed25519.pub
    ];
  };
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    htop
    btop
    nodejs_20
    ffmpeg
    yt-dlp
  ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.settings.auto-optimise-store = true;
  services.fstrim.enable = true;
  services.xserver.enable = false;
  sound.enable = false;
}
