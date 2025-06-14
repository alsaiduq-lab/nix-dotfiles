{pkgs, ...}: {
  home.packages = [
    (pkgs.ffmpeg-full.override {withXcb = true;})
  ];
}
