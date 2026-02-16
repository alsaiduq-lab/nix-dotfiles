{pkgs, ...}: {
  home.packages = with pkgs; [
    ffmpeg
    gpu-screen-recorder
  ];
}
