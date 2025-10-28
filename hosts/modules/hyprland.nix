{
  lib,
  config,
  pkgs,
  ...
}: {
  services.xserver.enable = false;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-hyprland xdg-desktop-portal-gtk];
    config = {
      common.default = ["gtk"];
      hyprland.default = ["hyprland" "gtk"];
    };
  };

  security.polkit.enable = true;

  services.accounts-daemon.enable = true;

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
