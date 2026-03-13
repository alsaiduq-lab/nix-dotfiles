{
  config,
  pkgs,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "595.45.04";
      sha256_64bit = "sha256-zUllSSRsuio7dSkcbBTuxF+dN12d6jEPE0WgGvVOj14=";
      openSha256 = "sha256-uqNfImwTKhK8gncUdP1TPp0D6Gog4MSeIJMZQiJWDoE=";
      settingsSha256 = "sha256-Y45pryyM+6ZTJyRaRF3LMKaiIWxB5gF5gGEEcQVr9nA=";
      persistencedSha256 = "sha256-5FoeUaRRMBIPEWGy4Uo0Aho39KXmjzQsuAD9m/XkNpA=";
    };
  };

  hardware.nvidia-container-toolkit.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [nvidia-vaapi-driver];
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      cudaPackages.cudatoolkit
      cudaPackages.cudnn
      cudaPackages.nccl
      config.hardware.nvidia.package
    ];
  };

  environment.variables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    CUDA_HOME = "${pkgs.cudaPackages.cudatoolkit}";
    CPATH = "${pkgs.cudaPackages.cudatoolkit}/include";
  };

  environment.systemPackages = with pkgs; [
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
