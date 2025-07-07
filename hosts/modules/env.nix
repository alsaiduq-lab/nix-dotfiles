{
  pkgs,
  lib,
  ...
}: {
  environment.shellInit = ''
    [ -d "$HOME/.cargo/bin"     ] && PATH+=":$HOME/.cargo/bin"
    [ -d "$HOME/.npm-global/bin"] && PATH+=":$HOME/.npm-global/bin"
  '';

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERM = "ghostty";
    CC = "${pkgs.gcc}/bin/gcc";

    LUA_PATH = "${pkgs.luajit}/share/lua/5.1/?.lua;${pkgs.luajit}/share/lua/5.1/?/init.lua;;";
    LUA_CPATH = "${pkgs.luajit}/lib/lua/5.1/?.so;;";

    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";

    PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" [
      pkgs.wayland
      pkgs.wayland-protocols
      pkgs.xkbcommon
      pkgs.mesa
      pkgs.openssl.dev
      pkgs.libxml2.dev
      pkgs.zlib.dev
      pkgs.portaudio
      pkgs.alsa-lib
      pkgs.stdenv.cc.cc
    ];

    LD_LIBRARY_PATH = lib.makeLibraryPath [
      pkgs.libglvnd
      pkgs.mesa
      pkgs.gcc-unwrapped.lib
      pkgs.linuxPackages.nvidia_x11
      pkgs.cudatoolkit
      pkgs.mangohud
      pkgs.portaudio
      pkgs.alsa-lib
      pkgs.stdenv.cc.cc.lib
      pkgs.wayland
      pkgs.xkbcommon
      pkgs.glib
    ];
  };

  environment.pathsToLink = [
    "/share/fish"
    "/bin"
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
