{ pkgs, ... }:
{
  services.tailscale = {
    enable = true;
    # some tailscale update forced this
    package = pkgs.tailscale.overrideAttrs (_: {
      doCheck = false;
      checkPhase = "true";
    });
  };

  networking.firewall = {
    allowedUDPPorts = [ 41641 ];
    trustedInterfaces = [ "tailscale0" ];
  };
}
