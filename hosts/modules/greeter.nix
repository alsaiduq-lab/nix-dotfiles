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
}
