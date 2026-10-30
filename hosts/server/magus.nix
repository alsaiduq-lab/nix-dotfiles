{
  pkgs,
  modulesPath,
  settings,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./boot.nix
    ./disk-config.nix
    ./gc.nix
    ./hardware-configuration.nix
    ./networking.nix
    ../modules/server.nix
  ];

  config = {
    system.stateVersion = "26.05";

    programs.fish.enable = true;
    environment.systemPackages = with pkgs; [
      xclip
      direnv
    ];

    nix.settings.trusted-users = [settings.user];

    programs.nix-ld.enable = true;

    services = {
      fstrim.enable = true;
      xserver.enable = false;
    };
  };
}
