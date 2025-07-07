{pkgs, ...}: {
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "amd";
    server.port = 6742;
  };

  services.udev.packages = [pkgs.openrgb-with-all-plugins];
  boot.kernelModules = ["i2c-dev" "i2c-piix4"];
  users.groups.i2c.members = ["cobray"];

  systemd.services.openrgb.serviceConfig.Environment = "QT_QPA_PLATFORM=offscreen";
}
