{
  config,
  pkgs,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = true;
    modesetting.enable = true; # must be true for Wayland
    powerManagement.enable = false;
    nvidiaSettings = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      cudaPackages.cudatoolkit.lib
      cudaPackages.cudnn
      cudaPackages.nccl
    ];
  };

  environment.systemPackages = with pkgs; [
    glxinfo
    cudaPackages.cudatoolkit
  ];
}
