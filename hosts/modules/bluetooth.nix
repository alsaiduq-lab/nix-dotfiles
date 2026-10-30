{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    input.General.ClassicBondedOnly = false;
  };
  services.blueman.enable = true;
  environment.systemPackages = with pkgs; [
    blueman
  ];
}
