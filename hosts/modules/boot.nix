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
      "rd.systemd.debug_shell"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "systemd.show_status=auto"
      "nowatchdog"
      "amd_iommu=on"
      "iommu=pt"
    ];
    kernelModules = ["ntsync"];
    blacklistedKernelModules = ["esp4" "esp6" "rxrpc"]; # in light of recent events
    kernel.sysctl = {
      "vm.swappiness" = 60;
      "vm.vfs_cache_pressure" = 50;
      "vm.compaction_proactiveness" = 0;
      "vm.page_lock_unfairness" = 1;
      "vm.max_map_count" = 2147483642; #SteamOS default
      "vm.dirty_ratio" = 15;
      "vm.dirty_background_ratio" = 5;
      "kernel.split_lock_mitigate" = 0;
      "kernel.nmi_watchdog" = 0;
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

  # some people really like putting #/bin/sh or #/bin/bash
  # this normally isnt recommended; i suggest yelling at people not knowing how to properly use shebangs
  system.activationScripts.binbash = {
    text = ''
      mkdir -p /bin
      ln -sf ${pkgs.bash}/bin/bash /bin/bash
    '';
  };
}
