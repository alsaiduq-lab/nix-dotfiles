{pkgs, ...}: {
  home.packages = with pkgs; [
    (ffmpeg.override {
      withXcb = true;
      withXlib = true;
    })
  ];
}
