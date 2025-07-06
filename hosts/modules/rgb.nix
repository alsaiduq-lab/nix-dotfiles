{pkgs, ...}: {
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "amd";
  };

  services.udev.packages = [pkgs.openrgb];
  boot.kernelModules = ["i2c-dev"];
  hardware.i2c.enable = true;
  environment.systemPackages = [pkgs.openrgb-with-all-plugins];

  systemd.services.openrgb-server = {
    description = "OpenRGB Network Server";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.openrgb-with-all-plugins}/bin/openrgb --server";
      Restart = "on-failure";
    };
  };
}
