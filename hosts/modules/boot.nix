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
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_latest;
    #50 series nvidia drivers are kinda a mess; use 6.12 if there's any issues
    #kernelPackages = pkgs.linuxPackages_6_12;
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
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1"
    ];
    # cpu specific optimizations
    kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
    };
  };

  # been annoying as of late
  systemd.oomd.enable = false;

  # some people really like putting #/bin/sh or #/bin/bash
  system.activationScripts.binbash = {
    deps = [];
    text = ''
      mkdir -p /bin
      if [ ! -e /bin/bash ]; then
        ln -sf ${pkgs.bash}/bin/bash /bin/bash
      fi
      mkdir -p /usr/bin
      if [ ! -e /usr/bin/env ]; then
        ln -sf ${pkgs.coreutils}/bin/env /usr/bin/env
      fi
    '';
  };
}
