{pkgs, ...}: {
  home.packages = with pkgs; [
    imagemagick
    pinta
    affinity-v3
  ];
}
