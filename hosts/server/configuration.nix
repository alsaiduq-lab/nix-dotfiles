{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  boot.loader.grub = {
    enable = true;
  };

  boot.initrd.availableKernelModules = ["xen_blkfront" "virtio_blk"];

  networking = {
    hostName = "alteur";
    useDHCP = false;
    interfaces.enX0.ipv4.addresses = [
      {
        address = "redacted";
        prefixLength = 24;
      }
    ];
    defaultGateway = "redacted";
    nameservers = ["8.8.8.8" "8.8.4.4"];
  };

  services.openssh = {
    enable = true;
    ports = [8123];
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "redacted"
  ];

  environment.systemPackages = with pkgs; [
    curl
    git
    htop
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [8123 80 443];
  };

  system.stateVersion = "25.05";
}
