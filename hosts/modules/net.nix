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
  ];

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
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

  services.openssh.enable = true;

  # Disable NetworkManager-wait-online to fix boot hang
  systemd.services."NetworkManager-wait-online".enable = false;
}
