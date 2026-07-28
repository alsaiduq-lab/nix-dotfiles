{
  config,
  pkgs,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    nvidiaPersistenced = true;

    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  hardware.nvidia-container-toolkit.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [nvidia-vaapi-driver];
  };

  environment.variables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    CUDA_HOME = "${pkgs.cudaPackages.cudatoolkit}";
    CPATH = "${pkgs.cudaPackages.cudatoolkit}/include";
  };

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
    mesa-demos
    vulkan-tools
    vulkan-headers
    vulkan-validation-layers
    libva-utils
    vdpauinfo
    egl-wayland
    cudaPackages.cudatoolkit
  ];
}
