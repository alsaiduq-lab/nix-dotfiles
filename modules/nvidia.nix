{
  config,
  pkgs,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = false;
    powerManagement.enable = false;
    # Set to true for RTX 4000 series and newer GPUs
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidiaSettings = true;
  };

  environment.systemPackages = with pkgs; [
    cudaPackages.cudatoolkit
    glxinfo
  ];
}
