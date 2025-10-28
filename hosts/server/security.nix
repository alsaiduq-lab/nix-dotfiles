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
  };

  users.users.root.openssh.authorizedKeys.keyFiles = [
    ../../.secrets/id_ed25519.pub
  ];

  users.users.admin = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"];
    openssh.authorizedKeys.keyFiles = [
      ../../.secrets/id_ed25519.pub
    ];
  };

  security.sudo.wheelNeedsPassword = false;
}
