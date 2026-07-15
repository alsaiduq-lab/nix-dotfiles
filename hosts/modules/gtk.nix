{settings, ...}: let
  gtkSettings = ''
    [Settings]
    gtk-application-prefer-${settings.gtkThemeMode}-theme=1
    gtk-theme-name=${settings.gtkTheme}
    gtk-icon-theme-name=${settings.iconTheme}
    gtk-font-name=${settings.font}
    gtk-cursor-theme-name=${settings.cursorName}
    gtk-cursor-theme-size=${toString settings.cursorSize}
  '';
in {
  environment.etc = {
    "gtk-2.0/gtkrc".text = ''
      gtk-theme-name="${settings.gtkTheme}"
      gtk-icon-theme-name="${settings.iconTheme}"
      gtk-font-name="${settings.font}"
      gtk-cursor-theme-name="${settings.cursorName}"
      gtk-cursor-theme-size=${toString settings.cursorSize}
    '';
    "gtk-3.0/settings.ini".text = gtkSettings;
    "gtk-4.0/settings.ini".text = gtkSettings;
    # fix for kde icon themes
    "xdg/kdeglobals".text = ''
      [Icons]
      Theme=${settings.iconTheme}
    '';
  };
  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = settings.gtkTheme;
        icon-theme = settings.iconTheme;
        cursor-theme = settings.cursorName;
        font-name = settings.font;
        color-scheme = "prefer-${settings.gtkThemeMode}";
      };
    }
  ];
  environment.sessionVariables = {
    GTK_THEME = "${settings.gtkTheme}:${settings.gtkThemeMode}";
  };
}
