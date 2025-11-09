{
  pkgs,
  inputs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    quickshell
    dmsCli
    dgop
    ddcutil
    cliphist
  ];
  home.sessionPath = ["${pkgs.quickshell}/bin"];
}
