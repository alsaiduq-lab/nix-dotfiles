{pkgs, ...}: {
  home.packages = [pkgs.openrgb-with-all-plugins];

  systemd.user.services.openrgb-gui = {
    Unit = {
      Description = "OpenRGB GUI (daemon)";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.openrgb-with-all-plugins}/bin/openrgb --gui --startminimized --server 127.0.0.1:6742 --profile default";
      Restart = "on-failure";
      Environment = "QT_QPA_PLATFORM=wayland;xcb";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
