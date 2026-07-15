{modulesPath, ...}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./anubis.nix
    ./bot.nix
    ./copyparty.nix
    ./forgejo.nix
    ./hermes.nix
    ./kuma.nix
    ./nginx.nix
    ./ntfy.nix
    ./redis.nix
    ./timezone.nix
    ./docker.nix
    ./npm.nix
    ./nixos.nix
    ./appimage.nix
    ./tailscale.nix
    ./python.nix
    ./go.nix
    ./searxng.nix
    ./sops.nix
    ../server/hardware-configuration.nix
    ../server/networking.nix
    ../server/disk-config.nix
    ../server/security.nix
  ];
}
