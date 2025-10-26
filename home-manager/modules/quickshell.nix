{
  pkgs,
  inputs,
  lib,
  ...
}: {

  home.packages = with pkgs; [
    quickshell
    dgop
    ddcutil
    accountsservice
    cliphist
  ];
  home.sessionPath = ["${pkgs.quickshell}/bin"];
}
