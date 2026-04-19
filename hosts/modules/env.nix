{
  config,
  pkgs,
  ...
}: {
  environment.variables = {
    EDITOR = config.theme.Editor;
    TERM = config.theme.Terminal;
    BROWSER = config.theme.Browser;
  };

  environment.sessionVariables = {
    XCURSOR_THEME = config.theme.cursorName;
    XCURSOR_SIZE = toString config.theme.cursorSize;
    QT_QPA_PLATFORMTHEME = config.theme.qtTheme;
    QT_STYLE_OVERRIDE = config.theme.qtOverride;
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    HYPRCURSOR_THEME = config.theme.cursorName;
    HYPRCURSOR_SIZE = toString config.theme.cursorSize;
  };
  environment.pathsToLink = [
    "/share/${config.theme.Shell}"
    "/bin"
    "/share/icons"
    "/share/pixmaps"
  ];
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
}
