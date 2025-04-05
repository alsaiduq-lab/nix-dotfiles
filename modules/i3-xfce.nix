{pkgs, ...}: let
  wallpapers = [
    "${pkgs.nixos-artwork.wallpapers.simple-dark-gray}/share/backgrounds/nixos/nixos-wallpaper.png"
    "${pkgs.nixos-artwork.wallpapers.gnome-dark}/share/backgrounds/gnome/gnome-dark.png"
    "${pkgs.nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nixos-wallpaper.png"
  ];

  randomWallpaper = pkgs.writeShellScript "wallpaper.sh" ''
    #!${pkgs.runtimeShell}
    set -e
    BG_DIR="/var/lib/lightdm-background"
    BG_LINK="$BG_DIR/current-wallpaper.png"
    mkdir -p "$BG_DIR"
    WALLPAPERS=( ${builtins.concatStringsSep " " (map (w: "\"${w}\"") wallpapers)} )
    COUNT=''${#WALLPAPERS[@]}
    if [[ "$COUNT" -eq 0 ]]; then exit 1; fi
    RAND=$(shuf -i 0-$(($COUNT - 1)) -n 1)
    SELECT=''${WALLPAPERS[$RAND]}
    ln -sf "$SELECT" "$BG_LINK"
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
      i3lock
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
    background = "/var/lib/lightdm-background/current-wallpaper.png";
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
    "L+ /var/lib/lightdm-background/current-wallpaper.png - - - - ${builtins.elemAt wallpapers 0}"
  ];

  systemd.services.random-wallpaper = {
    description = "Update wallpaper to a random image";
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
      gtk-icon-theme-name="candy-icons"
      gtk-font-name="Clear Sans 10"
      gtk-cursor-theme-name="capitaine-cursors"
      gtk-cursor-theme-size=24
    '';
    "gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=1
      gtk-theme-name=Tokyonight-Dark
      gtk-icon-theme-name="candy-icons"
      gtk-font-name="Clear Sans 10"
      gtk-cursor-theme-name="capitaine-cursors"
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
    breeze-icons
    gnome-themes-extra
  ];

  environment.pathsToLink = [
    "/share/icons"
    "/share/pixmaps"
  ];

  services.xserver.desktopManager.session = [
    {
      name = "xfce+i3";
      start = ''
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
