{pkgs, ...}: {
  services.xserver.enable = false;
  programs.gpu-screen-recorder.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  services.accounts-daemon.enable = true;

  environment.systemPackages = with pkgs; [
    hyprpolkitagent
    candy-icons
    magna-glassy-icons
    miyabi-cursor
    hyprlock
    wlogout
    wl-clipboard
    libnotify
    xclip
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
    khal
    cava
    matugen
    brightnessctl
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
