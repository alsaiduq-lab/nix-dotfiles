{pkgs, ...}: {
  home.packages = with pkgs; [
    linux-wallpaperengine
  ];
}
