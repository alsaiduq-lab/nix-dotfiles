{
  pkgs,
  lib,
  config,
  ...
}: {
  environment.variables = {
    EDITOR = config.theme.Editor;
    TERM = config.theme.Terminal;
    BROWSER = config.theme.Browser;
    XCURSOR_THEME = config.theme.cursorName;
    XCURSOR_SIZE = toString config.theme.cursorSize;
    GTK_THEME = "${config.theme.gtkTheme}:${config.theme.gtkThemeMode}";
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

    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";

    CC = "${pkgs.gcc}/bin/gcc";
    LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";

    LUA_PATH = "${pkgs.luajit}/share/lua/5.1/?.lua;${pkgs.luajit}/share/lua/5.1/?/init.lua;;";
    LUA_CPATH = "${pkgs.luajit}/lib/lua/5.1/?.so;;";

    PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" [
      pkgs.portaudio
      pkgs.alsa-lib
      pkgs.stdenv.cc.cc
    ];

    LD_LIBRARY_PATH = lib.makeLibraryPath [
      pkgs.libglvnd
      pkgs.mesa
      pkgs.cudatoolkit
      pkgs.mangohud
      pkgs.portaudio
      pkgs.alsa-lib
      pkgs.wayland
      pkgs.libxkbcommon
      pkgs.glib
    ];

    CUDA_HOME = pkgs.cudatoolkit;
    CPATH = "${pkgs.cudatoolkit}/include";
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
}
