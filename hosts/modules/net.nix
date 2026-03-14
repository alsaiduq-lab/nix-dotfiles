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
  ];

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    firewall = {
      enable = true;
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

  systemd.services."NetworkManager-wait-online".enable = false;
}
