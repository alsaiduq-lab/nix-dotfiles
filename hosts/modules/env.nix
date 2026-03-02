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
    QT_QPA_PLATFORMTHEME = config.theme.qtTheme;
    QT_STYLE_OVERRIDE = config.theme.qtOverride;
    CC = "${pkgs.gcc}/bin/gcc";
    LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
    LUA_PATH = "${pkgs.luajit}/share/lua/${pkgs.luajit.luaversion}/?.lua;${pkgs.luajit}/share/lua/${pkgs.luajit.luaversion}/?/init.lua;;";
    LUA_CPATH = "${pkgs.luajit}/lib/lua/${pkgs.luajit.luaversion}/?.so;;";
  };

  environment.sessionVariables = {
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
