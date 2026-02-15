{pkgs, ...}: {
  services.xserver.enable = false;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      Hyprland.default = ["hyprland" "gtk"];
    };
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.polkit.enable = true;

  services.accounts-daemon.enable = true;
  systemd.user.targets.graphical-session = {
    unitConfig = {
      RefuseManualStart = false;
      StopWhenUnneeded = false;
    };
    wantedBy = ["default.target"];
  };

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "hyprpolkitagent" ''
      exec ${hyprpolkitagent}/libexec/hyprpolkitagent "$@"
    '')
    qt5.qtwayland
    qt6.qtwayland
    candy-icons
    firefly-cursor
    tokyonight-gtk-theme
    hyprlock
    wlogout
    wl-clipboard
    xclip
    rofi
    wofi
    hyprshot
    hypridle
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
    matugen
    brightnessctl
    xwayland-satellite
    hyprshade
  ];
}
