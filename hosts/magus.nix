{
  pkgs,
  modulesPath,
  lib,
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
    ./modules/minijinja.nix
    ./modules/python.nix
    ./modules/go.nix
    ./modules/misc.nix
    ./modules/searxng.nix
    ./server/forgejo.nix
    ./server/copyparty.nix
    ./server/bot.nix
    ./server/ntfy.nix
    ./server/kuma.nix
    ./server/nginx.nix
    #./modules/syncthing.nix
    ./modules/sops.nix
    ./server/hermes.nix
    #./server/umami.nix
    #./server/homepage.nix
    ./server/anubis.nix
  ];

  options = {
    theme.user = lib.mkOption {
      type = lib.types.str;
      default = "alteur";
    };

    server = {
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "monaie.ca";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8123;
      };
    };
  };

  config = {
    system.stateVersion = "26.05";
    boot.loader.grub = {
      enable = true;
      efiSupport = false;
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "riiidge.racer@gmail.com";
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
  };
}
