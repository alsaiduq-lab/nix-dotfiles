{pkgs, ...}: {
  home.packages = [pkgs.thorium];
  xdg.dataFile = {
    "icons/hicolor" = {
      source = "${pkgs.thorium}/share/icons/hicolor";
      recursive = true;
    };
  };
}
