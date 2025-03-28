{
  pkgs,
  ...
}: {
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.timeout = 5;
  # Create the traditional /bin directory with a symlink to bash for scripts
  system.activationScripts.binbash = {
    deps = [];
    text = ''
      mkdir -p /bin
      ln -sf ${pkgs.bash}/bin/bash /bin/bash
      mkdir -p /usr/bin
      ln -sf ${pkgs.coreutils}/bin/env /usr/bin/env
    '';
  };
}
