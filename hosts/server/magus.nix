{
  pkgs,
  modulesPath,
  lib,
  ...
}: {
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
