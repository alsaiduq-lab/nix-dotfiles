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

  systemd.services.greetd.preStart = lib.mkAfter ''
    install -d -o dms-greeter -g dms-greeter -m 0750 \
      /var/lib/dms-greeter/.local \
      /var/lib/dms-greeter/.local/state \
      /var/lib/dms-greeter/.local/share \
      /var/lib/dms-greeter/.cache
  '';
}
