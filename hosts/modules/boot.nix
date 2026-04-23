{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      timeout = 5;
    };
    tmp = {
      useTmpfs = true;
      tmpfsSize = "67%";
    };
    kernelPackages = pkgs.linuxPackages_latest;
    consoleLogLevel = 3;
    initrd = {
      verbose = false;
      kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
    };
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
      "nowatchdog"
    ];
    kernelModules = ["tcp_bbr"];
    kernel.sysctl = {
      "vm.swappiness" = 60;
      "vm.vfs_cache_pressure" = 50;
      "vm.compaction_proactiveness" = 0;
      "vm.page_lock_unfairness" = 1;
      "vm.max_map_count" = 2147483642; #SteamOS default
      "kernel.split_lock_mitigate" = 0;
      "net.core.rmem_max" = 16777216;
      "net.core.wmem_max" = 16777216;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
    kernelPatches = [
      {
        name = "Rust";
        patch = null;
        features = {
          rust = true;
        };
      }
    ];
  };

  # redirect builds to disk so tmpfs doesn't blow up
  systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp";

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };
  systemd.oomd.enable = true;

  # some people really like putting #/bin/sh or #/bin/bash
  system.activationScripts.binbash = {
    deps = [];
    text = ''
      mkdir -p /bin
      if [ ! -e /bin/bash ]; then
        ln -sf ${pkgs.bash}/bin/bash /bin/bash
      fi
      mkdir -p /usr/bin
    '';
  };
}
