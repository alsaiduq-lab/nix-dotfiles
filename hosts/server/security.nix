{
  config,
  pkgs,
  ...
}: {
  services.openssh = {
    enable = true;
    ports = [8123];
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK29z1CTXF77ykGyklPM8X3SxeMYM7zHyoIDGi2C9/HU riiidge.racer@gmail.com"
  ];
  users.users.alteur = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["wheel" "docker"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK29z1CTXF77ykGyklPM8X3SxeMYM7zHyoIDGi2C9/HU riiidge.racer@gmail.com"
    ];
  };
  security.sudo.wheelNeedsPassword = false;
}
