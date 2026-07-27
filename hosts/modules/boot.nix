{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 8;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      timeout = 5;
    };
    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
    };
    kernelPackages = pkgs.linuxPackages_latest;
    consoleLogLevel = 3;
    initrd = {
      systemd.enable = true;
      verbose = false;
      kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
    };
    kernelParams = [
      "quiet"
      "splash"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "systemd.show_status=auto"
      "nowatchdog"
      "amd_iommu=on"
    ];
    kernelModules = ["ntsync"];
    blacklistedKernelModules = ["esp4" "esp6" "rxrpc"]; # in light of recent events
    kernel.sysctl = {
      "vm.swappiness" = 150;
      "vm.max_map_count" = 2147483642; #SteamOS default
      "net.core.rmem_max" = 16777216;
      "net.core.wmem_max" = 16777216;
      "net.ipv4.tcp_rmem" = "4096 131072 16777216";
      "net.ipv4.tcp_wmem" = "4096 65536 16777216";
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "fq";
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };
}
