{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    networkmanager_dmenu
    networkmanagerapplet
  ];

  networking.firewall.allowedTCPPorts = [57621];
  networking.firewall.allowedUDPPorts = [5353];

  networking.wireless.enable = false; # Enables wireless support via wpa_supplicant.
  networking.hostName = "nixos";
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
