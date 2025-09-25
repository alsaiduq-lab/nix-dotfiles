{
  config,
  pkgs,
  ...
}: let
  t = config.theme;
  cursorName = t.cursorName;
  cursorSize = toString t.cursorSize;
  gtkTheme = t.gtkTheme;
  iconTheme = t.iconTheme;
  fontName = t.fontName;
in {
  environment.etc = {
    "gtk-2.0/gtkrc".text = ''
      gtk-theme-name=${gtkTheme}
      gtk-icon-theme-name=${iconTheme}
      gtk-font-name=${fontName}
      gtk-cursor-theme-name=${cursorName}
      gtk-cursor-theme-size=${cursorSize}
    '';
    "gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=1
      gtk-theme-name=${gtkTheme}
      gtk-icon-theme-name=${iconTheme}
      gtk-font-name=${fontName}
      gtk-cursor-theme-name=${cursorName}
      gtk-cursor-theme-size=${cursorSize}
    '';
    "gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=1
      gtk-theme-name=${gtkTheme}
      gtk-icon-theme-name=${iconTheme}
      gtk-font-name=${fontName}
      gtk-cursor-theme-name=${cursorName}
      gtk-cursor-theme-size=${cursorSize}
    '';
  };

  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = gtkTheme;
        icon-theme = iconTheme;
        cursor-theme = cursorName;
        font-name = fontName;
      };
    }
  ];
}
