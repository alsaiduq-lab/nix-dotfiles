{ config, pkgs, lib, ... }:

let
  customPkgs = import ../pkgs { inherit pkgs lib; };
in
{
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
      # Set random wallpaper
      ${pkgs.feh}/bin/feh --randomize --bg-fill ~/wallpapers/* || ${pkgs.feh}/bin/feh --bg-fill ${pkgs.nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nineish-dark-gray.png &
      export GTK_THEME="Tokyonight-Dark"
      export XCURSOR_THEME="Vivid-Dark-Icons"
      export XCURSOR_SIZE="24"
      export QT_STYLE_OVERRIDE="adwaita-dark"
      ${pkgs.gtk3}/bin/gsettings set org.gnome.desktop.interface gtk-theme "Tokyonight-Dark"
      ${pkgs.gtk3}/bin/gsettings set org.gnome.desktop.interface icon-theme "Vivid-Dark-Icons"
    '';
  };

  services.xserver.desktopManager.xfce = {
    enable = true;
    noDesktop = true;
    enableXfwm = false;
  };

  services.xserver.displayManager.lightdm = {
    enable = true;
    background = "#000000";
    greeters.gtk = {
      enable = true;
      theme = {
        package = customPkgs.tokyo-night-gtk;
        name = "Tokyonight-Dark";
      };
      iconTheme = {
        package = customPkgs.vivid-icons;
        name = "Vivid-Dark-Icons";
      };
      extraConfig = ''
        [greeter]
        theme-name=Tokyonight-Dark
        icon-theme-name=Vivid-Dark-Icons
        font-name=Clear Sans 10
        cursor-theme-name=Vivid-Dark-Icons
      '';
    };
  };

  services.displayManager.defaultSession = "xfce+i3";
  services.displayManager.autoLogin = {
    enable = true;
    user = "cobray";
  };

  environment.etc."xdg/autostart/i3-setup.desktop" = {
    text = ''
      [Desktop Entry]
      Type=Application
      Name=i3 Setup
      Exec=${pkgs.bash}/bin/bash -c "${pkgs.feh}/bin/feh --randomize --bg-fill ~/wallpapers/* || ${pkgs.feh}/bin/feh --bg-fill ${pkgs.nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nineish-dark-gray.png"
      Terminal=false
      X-GNOME-Autostart-enabled=true
    '';
    mode = "0644";
  };

  qt.enable = true;
  qt.platformTheme = "qt5ct";
  qt.style = "adwaita-dark";

  environment.etc."gtk-2.0/gtkrc".text = ''
    gtk-theme-name="Tokyonight-Dark"
    gtk-icon-theme-name="Vivid-Dark-Icons"
    gtk-font-name="Clear Sans 10"
  '';

  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
    gtk-theme-name=Tokyonight-Dark
    gtk-icon-theme-name=Vivid-Dark-Icons
    gtk-font-name=Clear Sans 10
  '';

  environment.etc."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
    gtk-theme-name=Tokyonight-Dark
    gtk-icon-theme-name=Vivid-Dark-Icons
    gtk-font-name=Clear Sans 10
  '';

  environment.variables = {
    GTK_THEME = "Tokyonight-Dark";
    XCURSOR_THEME = "Vivid-Dark-Icons";
    XCURSOR_SIZE = "24";
    QT_STYLE_OVERRIDE = "adwaita-dark";
    GTK2_RC_FILES = "$HOME/.gtkrc-2.0";
  };

  environment.systemPackages = with pkgs; [
    arandr
    nitrogen
    xclip
    lxappearance
    libsForQt5.qt5ct
    gnome-themes-extra
    gsettings-desktop-schemas
    adwaita-qt
    arc-theme
    arc-icon-theme
    papirus-icon-theme
    numix-icon-theme-circle
    candy-icons
  ] ++ (with customPkgs; [
    tokyo-night-gtk
    vivid-icons
  ]);
}
