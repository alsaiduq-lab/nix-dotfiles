{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    wget
    curl
    aria2
    cloudflared
    nmap
    httpie
    socat
    posting
    mtr
    openssl
    cacert
  ];

  networking = {
    hostName = "nixos";
    useDHCP = false;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    firewall = {
      enable = true;
      checkReversePath = "loose";
      allowedTCPPorts = [80 443 57621];
      allowedTCPPortRanges = [
        {
          from = 6000;
          to = 6767;
        }
      ];
      allowedUDPPorts = [5353];
    };
  };

  services.resolved.enable = true;

  systemd.services."NetworkManager-wait-online".enable = false;
}
