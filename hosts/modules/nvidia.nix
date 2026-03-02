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

    package = let
      base = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "590.48.01";
        sha256_64bit = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
        openSha256 = "sha256-hECHfguzwduEfPo5pCDjWE/MjtRDhINVr4b1awFdP44=";
        settingsSha256 = "sha256-4SfCWp3swUp+x+4cuIZ7SA5H7/NoizqgPJ6S9fm90fA=";
        persistencedSha256 = "sha256-wsNeuw7IaY6Qc/i/AzT/4N82lPjkwfrhxidKWUtcwW8=";
      };

      cachyosPatch = pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/master/nvidia/nvidia-utils/kernel-6.19.patch";
        sha256 = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
      };
    in
      base
      // {
        open = base.open.overrideAttrs (old: {
          patches = (old.patches or []) ++ [cachyosPatch];
        });
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
