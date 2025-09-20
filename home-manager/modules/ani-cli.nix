{pkgs, ...}: {
  home.packages = with pkgs; [
    ani-cli
    aria2
  ];
}
