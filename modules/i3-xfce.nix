{pkgs, ...}: let
  wallpaperDir = "/home/cobray/wallpapers";

  randomWallpaper = pkgs.writeShellScript "wallpaper.sh" ''
    #!${pkgs.runtimeShell}
    set -e
    BG_DIR="/var/lib/lightdm-background"
    BG_LINK="$BG_DIR/random-wallpaper.png"
    LAST_WALLPAPER="$BG_DIR/.last-wallpaper"
    WALLPAPER_DIR="${wallpaperDir}"

    mkdir -p "$BG_DIR"
    rm -f "$BG_LINK"
    mapfile -t WALLPAPERS < <(${pkgs.findutils}/bin/find "$WALLPAPER_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \))
    COUNT=''${#WALLPAPERS[@]}
    if [[ "$COUNT" -eq 0 ]]; then
      cp -f "${pkgs.nixos-artwork.wallpapers.simple-dark-gray}/share/backgrounds/nixos/nixos-wallpaper.png" "$BG_LINK"
      echo "${pkgs.nixos-artwork.wallpapers.simple-dark-gray}/share/backgrounds/nixos/nixos-wallpaper.png" > "$LAST_WALLPAPER"
      chown lightdm:lightdm "$BG_LINK" "$LAST_WALLPAPER"
      exit 0
    fi
    RAND=$(${pkgs.coreutils}/bin/shuf -i 0-$(($COUNT - 1)) -n 1)
    SELECT=''${WALLPAPERS[$RAND]}
    cp -f "$SELECT" "$BG_LINK"
    echo "$SELECT" > "$LAST_WALLPAPER"
    chown lightdm:lightdm "$BG_LINK" "$LAST_WALLPAPER"
  '';
in {
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    extraPackages = with pkgs; [
      dmenu
      i3status
      i3lock-color
      i3blocks
      picom
      feh
      rofi
      dunst
      polybar
      i3-auto-layout
      xsettingsd
    ];
    extraSessionCommands = ''
      if [ -f /var/lib/lightdm-background/.last-wallpaper ]; then
        ${pkgs.feh}/bin/feh --bg-fill "$(cat /var/lib/lightdm-background/.last-wallpaper)"
      fi

      export GSETTINGS_SCHEMA_DIR="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas"
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme "Tokyonight-Dark"
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface icon-theme "candy-icons"
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme "capitaine-cursors"
      cat > $HOME/.config/xsettingsd << EOF
      Net/ThemeName "Tokyonight-Dark"
      Net/IconThemeName "candy-icons"
      Gtk/CursorThemeName "capitaine-cursors"
      EOF
      killall xsettingsd || true
      ${pkgs.xsettingsd}/bin/xsettingsd &
    '';
  };

  services.xserver.desktopManager.xfce = {
    enable = true;
    noDesktop = true;
    enableXfwm = false;
  };

  services.xserver.displayManager.lightdm = {
    enable = true;
    background = "/var/lib/lightdm-background/random-wallpaper.png";
    greeters.gtk = {
      enable = true;
      theme = {
        package = pkgs.tokyonight-gtk-theme;
        name = "Tokyonight-Dark";
      };
      iconTheme = {
        package = pkgs.candy-icons;
        name = "candy-icons";
      };
      cursorTheme = {
        package = pkgs.capitaine-cursors;
        name = "capitaine-cursors";
      };
      extraConfig = ''
        [greeter]
        greeting = Welcome back, Traveller
        font-name=Clear Sans 10
        cursor-theme-name=capitaine-cursors
        icon-theme-name=candy-icons
      '';
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/lightdm-background 0755 lightdm lightdm - -"
    "d ${wallpaperDir} 0755 cobray users - -"
    "f /var/log/random-wallpaper.log 0644 root root - -"
  ];

  systemd.services.random-wallpaper = {
    description = "Update wallpaper to a random image";
    before = ["display-manager.service"];
    wantedBy = ["display-manager.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${randomWallpaper}";
      User = "root";
    };
  };

  systemd.timers.random-wallpaper = {
    description = "Daily wallpaper refresh for LightDM";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  services.displayManager.defaultSession = "xfce+i3";
  services.displayManager.autoLogin = {
    enable = true;
    user = "cobray";
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  environment.etc = {
    "gtk-2.0/gtkrc".text = ''
      gtk-theme-name="Tokyonight-Dark"
      gtk-icon-theme-name="candy-icons"
      gtk-font-name="Clear Sans 10"
      gtk-cursor-theme-name="capitaine-cursors"
      gtk-cursor-theme-size=24
    '';
    "gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=1
      gtk-theme-name=Tokyonight-Dark
      gtk-icon-theme-name=candy-icons
      gtk-font-name=Clear Sans 10
      gtk-cursor-theme-name=capitaine-cursors
      gtk-cursor-theme-size=24
    '';
    "gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=1
      gtk-theme-name=Tokyonight-Dark
      gtk-icon-theme-name=candy-icons
      gtk-font-name=Clear Sans 10
      gtk-cursor-theme-name=capitaine-cursors
      gtk-cursor-theme-size=24
    '';
  };

  environment.systemPackages = with pkgs; [
    arandr
    xclip
    lxappearance
    gsettings-desktop-schemas
    adwaita-qt
    candy-icons
    capitaine-cursors
    tokyonight-gtk-theme
    xsettingsd
    hicolor-icon-theme
    adwaita-icon-theme
    kdePackages.breeze-icons
    gnome-themes-extra
    findutils
    coreutils
    feh
  ];

  environment.pathsToLink = [
    "/share/icons"
    "/share/pixmaps"
  ];

  services.xserver.desktopManager.session = [
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

  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          icon-theme = "candy-icons";
          gtk-theme = "Tokyonight-Dark";
          cursor-theme = "capitaine-cursors";
        };
      };
    }
  ];
}
