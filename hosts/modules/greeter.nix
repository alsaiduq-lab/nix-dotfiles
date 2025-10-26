{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.dankMaterialShell.nixosModules.greeter
  ];

  programs.dankMaterialShell.greeter = {
    enable = true;
    compositor.name = "hyprland";
    configHome = "/home/${config.theme.user}";
  };
}
