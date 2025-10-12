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

  services.greetd = {
    enable = true;
    package = pkgs.greetd.tuigreet;
    settings.default_session = {
      user = "greeter";
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd ${pkgs.hyprland}/bin/Hyprland";
    };
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
    # hyprspace
    kdePackages.xwaylandvideobridge
  ];
}
