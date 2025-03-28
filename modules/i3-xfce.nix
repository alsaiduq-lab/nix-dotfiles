{
  pkgs,
  lib,
  ...
}: let
  customPkgs = import ../pkgs {inherit pkgs lib;};
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
    ];
    extraSessionCommands = ''
      ${pkgs.feh}/bin/feh --randomize --bg-fill ~/wallpapers/* 2>/dev/null || ${pkgs.feh}/bin/feh --bg-fill ${pkgs.nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nineish-dark-gray.png &

      export GSETTINGS_SCHEMA_DIR="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas"
      export XDG_DATA_DIRS="${pkgs.gsettings-desktop-schemas}/share:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:${pkgs.tokyonight-gtk-theme}/share:${customPkgs.vivid-icons}/share:$XDG_DATA_DIRS"

      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme "Tokyonight-Dark" || echo "Failed to set GTK theme" > /tmp/theme-debug.log
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface icon-theme "Vivid-Magna-Glassy-Dark-Icons" || ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark" || echo "Failed to set icon theme" > /tmp/theme-debug.log
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme "capitaine-cursors" || echo "Failed to set cursor theme" > /tmp/theme-debug.log
    '';
  };

  services.xserver.desktopManager.xfce = {
    enable = true;
    noDesktop = true;
    enableXfwm = false;
  };

  services.xserver.displayManager.lightdm = {
    enable = true;
    background = "${pkgs.nixos-artwork.wallpapers.simple-dark-gray}/share/backgrounds/nixos/nixos-wallpaper.png";
    greeters.gtk = {
      enable = true;
      theme = {
        package = pkgs.tokyonight-gtk-theme;
        name = "Tokyonight-Dark";
      };
      iconTheme = {
        package = customPkgs.vivid-icons;
        name = "Vivid-Magna-Glassy-Dark-Icons";
      };
      cursorTheme = {
        package = pkgs.capitaine-cursors;
        name = "capitaine-cursors";
      };
      extraConfig = ''
        [greeter]
        font-name=Clear Sans 10
        cursor-theme-name=capitaine-cursors
      '';
    };
  };

  services.displayManager.defaultSession = "xfce+i3";
  services.displayManager.autoLogin = {
    enable = true;
    user = "cobray";
  };

  qt = {
    enable = true;
    platformTheme = "gtk2";
  };

  environment.etc = {
    "gtk-2.0/gtkrc".text = ''
      gtk-theme-name="Tokyonight-Dark"
      gtk-icon-theme-name="Vivid-Magna-Glassy-Dark-Icons"
      gtk-font-name="Clear Sans 10"
      gtk-cursor-theme-name="capitaine-cursors"
      gtk-cursor-theme-size=24
    '';
    "gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=1
      gtk-theme-name=Tokyonight-Dark
      gtk-icon-theme-name="Vivid-Magna-Glassy-Dark-Icons"
      gtk-font-name=Clear Sans 10
      gtk-cursor-theme-name="capitaine-cursors"
      gtk-cursor-theme-size=24
    '';
    "gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=1
      gtk-theme-name=Tokyonight-Dark
      gtk-icon-theme-name="Vivid-Magna-Glassy-Dark-Icons"
      gtk-font-name=Clear Sans 10
      gtk-cursor-theme-name="capitaine-cursors"
      gtk-cursor-theme-size=24
    '';
  };

  environment.variables = {
    GTK_THEME = "Tokyonight-Dark";
    ICON_THEME = "Vivid-Magna-Glassy-Dark-Icons";
    XCURSOR_THEME = "capitaine-cursors";
    XCURSOR_SIZE = "24";
  };

  environment.systemPackages = with pkgs; [
    arandr
    nitrogen
    xclip
    lxappearance
    gnome-themes-extra
    gsettings-desktop-schemas
    adwaita-qt
    arc-theme
    arc-icon-theme
    papirus-icon-theme
    numix-icon-theme-circle
    candy-icons
    capitaine-cursors
    tokyonight-gtk-theme
    nix-prefetch-git
  ] ++ (with customPkgs; [
    vivid-icons
  ]);

  services.xserver.desktopManager.session = [{
    name = "xfce+i3";
    start = ''
      export XDG_DATA_DIRS="${pkgs.tokyonight-gtk-theme}/share:${customPkgs.vivid-icons}/share:$XDG_DATA_DIRS"
      ${pkgs.xfce.xfce4-session}/bin/xfce4-session --with-ck-launch &
      ${pkgs.i3-gaps}/bin/i3
    '';
  }];

  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [{
    settings = {
      "org/gnome/desktop/interface" = {
        icon-theme = "Vivid-Magna-Glassy-Dark-Icons";
        gtk-theme = "Tokyonight-Dark";
        cursor-theme = "capitaine-cursors";
      };
    };
  }];
}
