{pkgs, ...}: {
  services.tailscale = {
    enable = true;
    extraSetFlags = ["--netfilter-mode=off"];
    # some tailscale update forced this
    package = pkgs.tailscale.overrideAttrs (_: {
      doCheck = false;
      checkPhase = "true";
    });
  };

  networking.firewall = {
    allowedUDPPorts = [41641];
    trustedInterfaces = ["tailscale0"];
  };

  networking.nftables = {
    enable = true;
    ruleset = ''
      table inet tailscale-mullvad {
        chain prerouting {
          type filter hook prerouting priority mangle; policy accept;
          ip saddr 100.64.0.0/27 return
          ip daddr 100.64.0.0/10 ct mark set 0x00000f41
          ip6 daddr fd7a:115c:a1e0::/48 ct mark set 0x00000f41
        }
        chain output {
          type route hook output priority mangle; policy accept;
          ip daddr 100.64.0.0/27 return
          ip daddr 100.64.0.0/10 ct mark set 0x00000f41
          ip6 daddr fd7a:115c:a1e0::/48 ct mark set 0x00000f41
        }
      }
    '';
  };
}
