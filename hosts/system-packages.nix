{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../settings.nix
    ./cachix.nix
    ./modules/gtk.nix
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
    ./modules/ollama.nix
    ./modules/cups.nix
    ./modules/rust.nix
    ./modules/core.nix
    ./modules/libs.nix
    ./modules/rgb.nix
    ./modules/hyprland.nix
    ./modules/searxng.nix
    ./modules/nano.nix
    ./modules/qt.nix
    ./modules/appimage.nix
    ./modules/greeter.nix
    ./modules/go.nix
    ./modules/flatpak.nix
    ./modules/aagl.nix
    inputs.nix-gaming.nixosModules.pipewireLowLatency
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
