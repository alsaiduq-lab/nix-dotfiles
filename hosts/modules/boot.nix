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
      cleanOnBoot = true;
    };
    kernelPackages = pkgs.linuxPackages;
  };

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
