{
  pkgs,
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
  };

  environment.pathsToLink = [
    "/share/${config.theme.Shell}"
    "/bin"
    "/share/icons"
    "/share/pixmaps"
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      libglvnd
      mesa
      cudatoolkit
      mangohud
      portaudio
      alsa-lib
      wayland
      libxkbcommon
      glib
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
