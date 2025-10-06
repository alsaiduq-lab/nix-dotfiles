{pkgs, ...}: {
  home.packages = with pkgs; [
    quickshell
  ];
  home.sessionPath = ["${pkgs.quickshell}/bin"];
}
