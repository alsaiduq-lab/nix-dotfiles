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
      theme.name = "Tokyonight-Storm-B";
      iconTheme.name = "Vivid-Dark-Icons";
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

  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
    gtk-theme-name=Tokyonight-Storm-B
    gtk-icon-theme-name=Vivid-Dark-Icons
    gtk-font-name=Sans 10
  '';

  environment.etc."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
    gtk-theme-name=Tokyonight-Storm-B
    gtk-icon-theme-name=Vivid-Dark-Icons
    gtk-font-name=Sans 10
  '';

  environment.systemPackages = with pkgs; [
    arandr
    nitrogen
    xclip
    lxappearance
    libsForQt5.qt5ct
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
