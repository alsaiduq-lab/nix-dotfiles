{pkgs, ...}: {
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
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
