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
  };

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
