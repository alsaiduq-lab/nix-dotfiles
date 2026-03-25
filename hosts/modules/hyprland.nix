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

  environment.systemPackages = with pkgs; [
    hyprpolkitagent
    qt5.qtwayland
    qt6.qtwayland
    candy-icons
    miku-cursor
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
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.ark
    kdePackages.gwenview
    kdePackages.kio-extras
    kdePackages.ffmpegthumbs
    kdePackages.filelight
  ];
}
