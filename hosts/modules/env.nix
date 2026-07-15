{
  settings,
  pkgs,
  ...
}: {
  environment.variables = {
    EDITOR = settings.Editor;
    TERMINAL = settings.Terminal;
    BROWSER = settings.Browser;
  };

  environment.sessionVariables = {
    XCURSOR_THEME = settings.cursorName;
    XCURSOR_SIZE = toString settings.cursorSize;
    QT_QPA_PLATFORMTHEME = settings.qtTheme;
    QT_STYLE_OVERRIDE = settings.qtOverride;
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    HYPRCURSOR_THEME = settings.cursorName;
    HYPRCURSOR_SIZE = toString settings.cursorSize;
  };
  environment.pathsToLink = [
    "/share/${settings.Shell}"
    "/bin"
    "/share/icons"
    "/share/pixmaps"
  ];
  environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
}
