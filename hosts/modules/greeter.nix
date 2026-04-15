{
  config,
  lib,
  pkgs,
  ...
}: {
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "hyprland";
    configHome = "/home/${config.theme.user}";
    quickshell.package = pkgs.quickshell;
    logs = {
      save = true;
      path = "/tmp/greeter.log";
    };
  };

  systemd.services.greetd.preStart = let
    cacheDir = "/var/lib/dms-greeter";
  in
    lib.mkAfter ''
      install -d -o dms-greeter -g dms-greeter -m 0750 \
        ${cacheDir}/.local \
        ${cacheDir}/.local/state \
        ${cacheDir}/.local/share \
        ${cacheDir}/.cache
    '';
}
