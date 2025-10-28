{
  pkgs,
  inputs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    quickshell
    DMShell
    dms-cli
    dgop
    ddcutil
    cliphist
  ];
  home.sessionPath = ["${pkgs.quickshell}/bin"];
}
