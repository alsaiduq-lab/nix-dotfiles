{
  config,
  pkgs,
  ...
}: {
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "hyprland";
    configHome = "/home/${config.theme.user}";
    configFiles = ["/home/${config.theme.user}/.config/DankMaterialShell/settings.json"];
    quickshell.package = pkgs.quickshell;
    logs = {
      save = true;
      path = "/tmp/greeter.log";
    };
  };
}
