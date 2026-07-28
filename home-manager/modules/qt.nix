{
  config,
  pkgs,
  settings,
  ...
}: {
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    qt5ctSettings.Appearance = {
      color_scheme_path = "${config.xdg.configHome}/qt5ct/colors/matugen.conf";
      custom_palette = true;
      icon_theme = settings.iconTheme;
      standard_dialogs = "xdgdesktopportal";
      style = "Fusion";
    };
    qt6ctSettings.Appearance = {
      color_scheme_path = "${config.xdg.configHome}/qt6ct/colors/matugen.conf";
      custom_palette = true;
      icon_theme = settings.iconTheme;
      standard_dialogs = "xdgdesktopportal";
      style = "Fusion";
    };
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
