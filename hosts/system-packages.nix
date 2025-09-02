{pkgs, ...}: {
  imports = [
    ./cachix.nix
    ./modules/audio.nix
    ./modules/bluetooth.nix
    ./modules/boot.nix
    ./modules/docker.nix
    ./modules/env.nix
    ./modules/fonts.nix
    ./modules/net.nix
    ./modules/nixos.nix
    ./modules/nvidia.nix
    ./modules/steam.nix
    ./modules/timezone.nix
    ./modules/user.nix
    ./modules/python.nix
    ./modules/npm.nix
    ./modules/tailscale.nix
    ./modules/ld.nix
    ./modules/x11.nix
    ./modules/i3-xfce.nix
    ./modules/ollama.nix
    ./modules/cups.nix
    ./modules/rust.nix
    ./modules/java.nix
    ./modules/go.nix
    ./modules/core.nix
    ./modules/libs.nix
    ./modules/rgb.nix
    ./modules/nano.nix
  ];
  npm.enable = true;
  services.udisks2.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
