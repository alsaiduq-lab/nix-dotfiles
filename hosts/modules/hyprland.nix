{pkgs, ...}: {
  services.xserver.enable = false;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config = {
      common = {
        default = ["gtk"];
      };
      hyprland = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = ["hyprland"];
        "org.freedesktop.impl.portal.Screenshot" = ["hyprland"];
      };
    };
  };

  security.polkit.enable = true;

  services.accounts-daemon.enable = true;

  systemd.user.services.hyprpolkitagent = {
    enable = true;
    wantedBy = ["graphical-session.target"];
  };

  environment.systemPackages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    candy-icons
    hu-tao-animated-cursor
    tokyonight-gtk-theme
    hyprlock
    wlogout
    wl-clipboard
    xclip
    wofi
    hyprshot
    hypridle
    hyprpolkitagent
    grim-hyprland
    slurp
    swappy
    satty
    imv
    syshud
    hyprpaper
    hyprpicker
    nwg-look
    gsimplecal
    kdePackages.xwaylandvideobridge
    matugen
    brightnessctl
    xwayland-satellite
  ];
}
