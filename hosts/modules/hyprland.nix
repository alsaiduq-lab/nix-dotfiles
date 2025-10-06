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
  systemd.user.services.xdg-desktop-portal-hyprland.unitConfig.ConditionPathExists = "%t/wayland-0";

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    polkit_gnome
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
    polkit_gnome
    grim
    slurp
    swappy
    imv
    syshud
    hyprpaper
  ];
}
