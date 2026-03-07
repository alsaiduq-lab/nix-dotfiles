{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.dms-plugins-registry.nixosModules.default];
  programs.dms-shell = {
    enable = true;
    quickshell.package = pkgs.quickshell;

    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    enableSystemMonitoring = true;
    enableVPN = false;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = false;
    enableClipboardPaste = true;

    plugins = {
      dankKDEConnect.enable = true;
      dankGifSearch.enable = true;
      calculator.enable = true;
      dockerManager.enable = true;
      developerUtilities.enable = true;
      emojiLauncher.enable = true;
      webSearch.enable = true;
      nixMonitor.enable = true;
    };
  };
}
