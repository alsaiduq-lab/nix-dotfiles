{
  config,
  pkgs,
  ...
}: {
  environment.etc = {
    "gtk-2.0/gtkrc".text = ''
      gtk-theme-name=${config.theme.gtkTheme}
      gtk-icon-theme-name=${config.theme.iconTheme}
      gtk-font-name=${config.theme.font}
      gtk-cursor-theme-name=${config.theme.cursorName}
      gtk-cursor-theme-size="${builtins.toString config.theme.cursorSize}"
    '';
    "gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-${config.theme.gtkThemeMode}-theme=1
      gtk-theme-name=${config.theme.gtkTheme}
      gtk-icon-theme-name=${config.theme.iconTheme}
      gtk-font-name=${config.theme.font}
      gtk-cursor-theme-name=${config.theme.cursorName}
      gtk-cursor-theme-size="${builtins.toString config.theme.cursorSize}"
    '';
    "gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-${config.theme.gtkThemeMode}-theme=1
      gtk-theme-name=${config.theme.gtkTheme}
      gtk-icon-theme-name=${config.theme.iconTheme}
      gtk-font-name=${config.theme.font}
      gtk-cursor-theme-name=${config.theme.cursorName}
      gtk-cursor-theme-size="${builtins.toString config.theme.cursorSize}"
    '';
  };

  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = config.theme.gtkTheme;
        icon-theme = config.theme.iconTheme;
        cursor-theme = config.theme.cursorName;
        font-name = config.theme.font;
        color-scheme = "prefer-${config.theme.gtkThemeMode}";
      };
    }
  ];

  environment.sessionVariables = {
    GTK_THEME = "${config.theme.gtkTheme}:${config.theme.gtkThemeMode}";
  };
}
