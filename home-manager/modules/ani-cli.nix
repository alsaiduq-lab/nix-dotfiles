{pkgs, ...}: {
  home.packages = with pkgs; [
    ani-cli
    aria2
    yt-dlp
  ];
}
