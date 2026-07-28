{
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./hardware-configuration.nix
    ./networking.nix
    ../modules/server.nix
  ];

  config = {
    system.stateVersion = "26.05";
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
  };
}
