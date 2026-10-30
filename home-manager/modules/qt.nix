{
  config,
  pkgs,
  settings,
  ...
}: let
  qtctSettings = {
    Appearance = {
      custom_palette = true;
      color_scheme_path = "${config.xdg.configHome}/qt6ct/colors/matugen.conf";
      style = "Fusion";
      icon_theme = settings.iconTheme;
      standard_dialogs = "default";
    };
  };
in {
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    qt5ctSettings = qtctSettings;
    qt6ctSettings = qtctSettings;
  };

  xdg.configFile."kdeglobals" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.dataHome}/color-schemes/DankMatugen.colors";
    force = true;
  };

  home.packages = with pkgs; [
    qt6.qtdeclarative
    qt6.qtwayland
    qt6.qtsvg
    qt6.qtmultimedia
    qt6.qtimageformats
    qt5.qtwayland
    qt6.qt5compat
  ];
}
