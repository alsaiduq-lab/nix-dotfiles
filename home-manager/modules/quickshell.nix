{
  pkgs,
  inputs,
  lib,
  ...
}: {
  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
    enableSystemMonitoring = true;
    enableVPN = false;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;
  };

  home.packages = with pkgs; [
    dms-shell
    dgop
    ddcutil
    cliphist
    kdePackages.dolphin
  ];
  home.sessionPath = ["${pkgs.quickshell}/bin"];
}
