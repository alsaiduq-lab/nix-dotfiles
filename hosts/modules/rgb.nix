{
  settings,
  pkgs,
  ...
}: {
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "amd";
  };

  systemd.services.openrgb.serviceConfig.Environment = ["QT_QPA_PLATFORM=offscreen"];

  hardware.i2c.enable = true;
  users.users.${settings.user}.extraGroups = ["i2c"];
}
