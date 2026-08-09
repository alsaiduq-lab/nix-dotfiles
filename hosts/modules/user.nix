{
  pkgs,
  settings,
  ...
}: {
  users.users.${settings.user} = {
    isNormalUser = true;
    shell = builtins.getAttr settings.Shell pkgs;
    extraGroups = ["wheel" "networkmanager" "docker" "video" "render" "input" "audio" "bluetooth"];
    linger = true;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
    extraConfig = ''
      Defaults pwfeedback
      Defaults !admin_flag
    '';
  };

  programs."${settings.Shell}".enable = true;

  nix.settings.trusted-users = ["root"];
}
