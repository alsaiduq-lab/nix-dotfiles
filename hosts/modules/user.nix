{
  pkgs,
  lib,
  config,
  ...
}: {
  users.users.${config.theme.user} = {
    isNormalUser = true;
    shell = builtins.getAttr config.theme.Shell pkgs;
    extraGroups = ["wheel" "networkmanager" "docker" "video" "render" "input" "audio"];
    linger = true;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  programs."${config.theme.Shell}".enable = true;

  nix.settings.trusted-users = ["root" config.theme.user];
}
