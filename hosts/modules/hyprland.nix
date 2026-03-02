{pkgs, ...}: {
  services.xserver.enable = false;
  programs.gpu-screen-recorder.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  services.accounts-daemon.enable = true;

  environment.variables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    hyprpolkitagent
    qt5.qtwayland
    qt6.qtwayland
    candy-icons
    furina-cursor
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
    kdePackages.kdeconnect-kde
  ];
}
