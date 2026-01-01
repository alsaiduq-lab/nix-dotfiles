{pkgs, ...}: {
  home.packages = with pkgs; [
    desktop-gremlin
  ];
}
