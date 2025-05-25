{pkgs, ...}: {
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./docker.nix
    ./env.nix
    ./fonts.nix
    ./i3-xfce.nix
    ./net.nix
    ./nixos.nix
    ./nvidia.nix
    ./steam.nix
    ./timezone.nix
    ./user.nix
    ./python.nix
    ./npm.nix
    ./tailscale.nix
    ./udiskie.nix
    # ./ollama.nix
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
