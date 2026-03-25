{...}: {
  services.tailscale = {
    enable = true;
    extraSetFlags = ["--netfilter-mode=off"];
  };

  networking.firewall = {
    allowedUDPPorts = [41641];
    trustedInterfaces = ["tailscale0"];
  };

  networking.nftables = {
    enable = true;
    ruleset = ''
      table inet tailscale-mullvad {
        chain output {
          type route hook output priority mangle; policy accept;
          ip daddr 100.64.0.5 udp dport 53 return
          ip daddr 100.64.0.5 tcp dport 53 return
          ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65
          ip6 daddr fd7a:115c:a1e0::/48 ct mark set 0x00000f41 meta mark set 0x6d6f6c65
        }
        chain prerouting {
          type filter hook prerouting priority mangle; policy accept;
          iifname "tailscale0" ct mark set 0x00000f41 meta mark set 0x6d6f6c65
        }
      }
    '';
  };
}
