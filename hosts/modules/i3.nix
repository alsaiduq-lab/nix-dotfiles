{pkgs, ...}: {
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraSessionCommands = ''
        if [ -f /var/lib/lightdm-background/.last-wallpaper ]; then
          ${pkgs.feh}/bin/feh --bg-fill "$(cat /var/lib/lightdm-background/.last-wallpaper)"
        fi
      '';
    };

    # this is actually here because i get peeved personally when I see a none in "none+i3"
    desktopManager.xfce = {
      enable = true;
      noDesktop = true;
      enableXfwm = false;
    };

    desktopManager.session = [
      {
        name = "xfce+i3";
        start = ''
          if [ -f /var/lib/lightdm-background/.last-wallpaper ]; then
            ${pkgs.feh}/bin/feh --bg-fill "$(cat /var/lib/lightdm-background/.last-wallpaper)"
          fi
          export XDG_DATA_DIRS="${pkgs.tokyonight-gtk-theme}/share:${pkgs.candy-icons}/share:${pkgs.hicolor-icon-theme}/share:${pkgs.adwaita-icon-theme}/share:$XDG_DATA_DIRS"
          ${pkgs.xfce.xfce4-session}/bin/xfce4-session --with-ck-launch &
          ${pkgs.i3-gaps}/bin/i3
        '';
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    dmenu
    i3status
    i3lock-color
    i3blocks
    picom
    feh
    i3-auto-layout
    yt-dlp
    flameshot
    imagemagick
    slop
    ghostscript
    via
    arandr
    xsettingsd
    lxappearance
    gsettings-desktop-schemas
    adwaita-qt
    candy-icons
    tokyonight-gtk-theme
    hicolor-icon-theme
    adwaita-icon-theme
    gnome-themes-extra
    findutils
    coreutils
    hu-tao-animated-cursor
  ];
}
