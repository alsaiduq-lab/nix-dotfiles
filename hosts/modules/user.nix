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
        ${settings.user} ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/nix-env
    '';
  };

  programs."${settings.Shell}".enable = true;

  nix.settings.trusted-users = ["root" settings.user];
}
