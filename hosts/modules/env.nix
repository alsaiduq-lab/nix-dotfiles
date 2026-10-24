{
  settings,
  pkgs,
  ...
}: {
  environment.sessionVariables = {
    EDITOR = settings.Editor;
    TERMINAL = settings.Terminal;
    BROWSER = settings.Browser;
    XCURSOR_THEME = settings.cursorName;
    XCURSOR_SIZE = toString settings.cursorSize;
    HYPRCURSOR_THEME = settings.cursorName;
    HYPRCURSOR_SIZE = toString settings.cursorSize;
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
  };

  environment.pathsToLink = [
    "/share/${settings.Shell}"
    "/share/icons"
    "/share/pixmaps"
  ];

  environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
}
