{ config, pkgs, lib, ... }:

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
      theme.name = "Adwaita-dark";
      iconTheme.name = "Papirus-Dark";
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
  qt.platformTheme = "gnome";
  qt.style = "adwaita-dark";
  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
    gtk-theme-name=Adwaita-dark
    gtk-icon-theme-name=Papirus-Dark
    gtk-font-name=Sans 10
  '';

  environment.systemPackages = with pkgs; [
    arandr
    nitrogen
    xclip
    lxappearance
    arc-theme
    arc-icon-theme
    papirus-icon-theme
    numix-icon-theme-circle
    candy-icons
  ];
}
