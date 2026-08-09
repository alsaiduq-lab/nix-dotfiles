{pkgs, ...}: {
  services.xserver.enable = false;
  programs.gpu-screen-recorder.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  services.accounts-daemon.enable = true;

  environment.systemPackages = with pkgs; [
    hyprpolkitagent
    candy-icons
    kdePackages.breeze-icons
    magna-glassy-icons
    miyabi-cursor
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
    hyprpaper
    hyprpicker
    nwg-look
    gsimplecal
    matugen
    brightnessctl
    xwayland-satellite
    kdePackages.kdeconnect-kde
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.ark
    kdePackages.gwenview
    kdePackages.kio-extras
    kdePackages.ffmpegthumbs
    kdePackages.filelight
    xdg-utils
    xdg-terminal-exec
    unrar # TODO: move
  ];
}
