{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.dms.homeModules.default
    inputs.dms-plugins-registry.homeModules.default
  ];

  programs.dank-material-shell = {
    enable = true;
    package = pkgs.dms-shell;
    quickshell.package = pkgs.quickshell;

    systemd = {
      enable = true;
      restartIfChanged = true;
    };

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

    settings = builtins.fromJSON (
      builtins.readFile "${inputs.self.outPath}/config/DankMaterialShell/settings.json"
    );
  };
}
