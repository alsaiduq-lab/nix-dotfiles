{
  inputs,
  pkgs,
  settings,
  ...
}: {
  imports = [
    inputs.dms.homeModules.default
    inputs.dms-plugins-registry.homeModules.default
  ];

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    package = pkgs.dms-shell;

    plugins = {
      dankKDEConnect.enable = true;
      dankGifSearch.enable = true;
      calculator.enable = true;
      dockerManager.enable = true;
      developerUtilities.enable = true;
      emojiLauncher.enable = true;
      webSearch.enable = true;
      nvidiaGpuDankbarMonitor.enable = true;
      usbManager.enable = true;
      discordVoice.enable = true;
      animeCalendar.enable = true;
      imageConverter.enable = true;
      airQuality.enable = true;
      dankAudioVisualizer.enable = true;
    };

    settings = let
      dms = builtins.fromJSON (
        builtins.readFile "${inputs.self.outPath}/config/DankMaterialShell/settings.json"
      );
    in
      dms
      // {
        cursorSettings =
          dms.cursorSettings
          // {
            theme = settings.cursorName;
            size = settings.cursorSize;
          };
      };
  };
}
