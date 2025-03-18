{
  config,
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
    extraPackages = with pkgs; [dmenu i3status i3lock i3blocks picom feh rofi dunst polybar i3-auto-layout];
    extraSessionCommands = ''
      ${pkgs.feh}/bin/feh --randomize --bg-fill ~/wallpapers/* || ${pkgs.feh}/bin/feh --bg-fill ${pkgs.nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nineish-dark-gray.png &
      ${pkgs.gtk3}/bin/gsettings set org.gnome.desktop.interface gtk-theme "Tokyo Night Storm"
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
        name = "Tokyo Night Storm";
      };
      iconTheme = {
        package = customPkgs.vivid-icons;
        name = "Vivid-Dark-Icons";
      };
      extraConfig = ''
        [greeter]
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

  qt.enable = true;
  qt.platformTheme = "qt5ct";
  qt.style = "adwaita-dark";

  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
    gtk-theme-name=Tokyo Night Storm
    gtk-icon-theme-name=Vivid-Dark-Icons
    gtk-font-name=Clear Sans 10
  '';

  environment.variables = {
    GTK_THEME = "Tokyo Night Storm";
    XCURSOR_THEME = "Vivid-Dark-Icons";
    XCURSOR_SIZE = "24";
  };

  environment.systemPackages = with pkgs;
    [
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
    ]
    ++ (with customPkgs; [
      tokyo-night-gtk
      vivid-icons
    ]);
}
