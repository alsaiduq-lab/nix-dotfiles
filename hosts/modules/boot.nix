{
  pkgs,
  wallpapers,
  ...
}: {
  boot = {
    loader = {
      limine = {
        enable = true;
        maxGenerations = 2;
        style.wallpapers = ["${wallpapers}/miku.jpeg"];
      };
      efi.canTouchEfiVariables = true;
      timeout = 5;
    };
    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
      tmpfsHugeMemoryPages = "within_size";
    };
    kernelPackages = pkgs.linuxPackages_latest;
    plymouth = {
      enable = true;
      themePackages = [pkgs.mikuboot];
      theme = "mikuboot";
    };
    consoleLogLevel = 3;
    initrd = {
      kernelModules = ["nvidia" "nvidia_modeset" "nvidia_drm"];
    };
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
      "nvidia.NVreg_EnableResizableBar=1"
      "nvidia_modeset.max_output_color_depth=8"
      "pci=realloc,big_root_window"
    ];
    kernelModules = ["ntsync" "tcp_bbr"];
    # in light of **even** more recent events, will update as needed
    blacklistedKernelModules = ["esp4" "esp6" "rxrpc" "nlmon" "act_pedit" "ksmbd"];
    kernel.sysctl = {
      "kernel.sysrq" = 176;
      "vm.swappiness" = 150;
      "vm.page-cluster" = 0;
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

  systemd.oomd.enableUserSlices = true;
}
