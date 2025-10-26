{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    qt6.qtdeclarative
    qt6.qtwayland
    qt6.qtsvg
    qt6.qtmultimedia
    qt6.qtimageformats
    qt5.qtwayland
  ];
}
