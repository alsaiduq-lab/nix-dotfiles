{
  lib,
  config,
  pkgs,
  ...
}: {
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "amd";
    server.port = 6742;
  };

  boot.kernelModules = ["i2c-dev" "i2c-piix4"];
  services.udev.packages = [pkgs.openrgb-with-all-plugins];

  users.groups = {
    i2c = {};
    plugdev = {};
  };

  users.users.${config.theme.user}.extraGroups = ["i2c" "plugdev"];

  systemd.services.openrgb.serviceConfig.Environment = ["QT_QPA_PLATFORM=offscreen"];
  environment.sessionVariables.QT_QPA_PLATFORM = "wayland;xcb";
}
