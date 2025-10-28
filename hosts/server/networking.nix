{
  config,
  lib,
  ...
}: {
  networking = {
    hostName = "magus";
    useDHCP = false;
    interfaces.enX0.ipv4.addresses = [
      {
        address = "104.152.210.245";
        prefixLength = 24;
      }
    ];
    defaultGateway = "104.152.210.1";
    nameservers = ["8.8.8.8" "8.8.4.4"];
    firewall = {
      enable = true;
      allowedTCPPorts = [8123 80 443];
    };
  };
}
