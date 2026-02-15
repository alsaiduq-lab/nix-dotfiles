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
    #kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = pkgs.linuxPackages_6_18;
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    # cpu specific optimizations
    kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
    };
  };

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
