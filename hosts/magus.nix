{
  pkgs,
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
    ./modules/tailscale.nix
    ./modules/rust.nix
    ./modules/python.nix
    ./modules/go.nix
    ./modules/misc.nix
    ./server/forgejo.nix
    ./server/copyparty.nix
  ];
  system.stateVersion = "25.11";

  boot.loader.grub = {
    enable = true;
    efiSupport = false;
  };

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    xclip
    direnv
  ];
  services = {
    fstrim.enable = true;
    xserver.enable = false;
  };
}
