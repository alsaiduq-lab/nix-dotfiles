{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.dankMaterialShell.nixosModules.greeter
  ];

  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "hyprland";
    configHome = "/home/${config.theme.user}";
  };

  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
    home = "/var/lib/greeter";
    createHome = true;
  };

  users.groups.greeter = {};

  systemd.tmpfiles.rules = [
    "d /var/lib/greeter/.config/systemd/user 0755 greeter greeter -"
    "L+ /var/lib/greeter/.config/systemd/user/xdg-desktop-portal-hyprland.service - - - - /dev/null"
  ];
}
