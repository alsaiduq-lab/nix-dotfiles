{pkgs, ...}: {
  home.packages = with pkgs; [
    ffmpeg
    wf-recorder
  ];
}
