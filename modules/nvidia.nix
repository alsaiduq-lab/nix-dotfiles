{ config, pkgs, lib, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    # Set to true for RTX 4000 series and newer GPUs
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidiaSettings = true;
  };

  environment.systemPackages = with pkgs; [
    cudaPackages.cudatoolkit
  ];
}
