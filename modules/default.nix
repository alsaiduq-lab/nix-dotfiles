{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./docker.nix
    ./env.nix
    ./fonts.nix
    ./home-manager.nix
    ./i3-xfce.nix
    ./net.nix
    ./nixos.nix
    ./nvidia.nix
    ./steam.nix
    ./timezone.nix
    ./user.nix
    ./torch.nix
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

  environment.systemPackages = with pkgs; [
    home-manager
  ];
}
