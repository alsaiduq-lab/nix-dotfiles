{config, ...}: {
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets.copyparty = {
      owner = "copyparty";
    };
  };
  services.copyparty = {
    enable = true;
    settings = {
      i = "127.0.0.1";
      p = [3923];
      e2dsa = true;
      e2ts = true;
      xff-src = "127.0.0.1";
      og-ua = "(Discord|Twitter|Slack)bot";
    };
    accounts = {
      admin.passwordFile = config.sops.secrets.copyparty.path;
    };
    volumes = {
      "/" = {
        path = "/srv/copyparty";
        access = {
          A = "admin";
          g = "*";
        };
        flags = {
          e2d = true;
          dedup = true;
        };
      };
    };
  };
  systemd.tmpfiles.rules = [
    "d /srv/copyparty 0750 copyparty copyparty -"
  ];
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."share.monaie.ca" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3923";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 0;
          proxy_buffering off;
          proxy_request_buffering off;
          proxy_buffers 32 8k;
          proxy_buffer_size 16k;
          proxy_busy_buffers_size 24k;
          proxy_set_header Connection "Keep-Alive";
          proxy_read_timeout 36000s;
          proxy_send_timeout 36000s;
        '';
      };
    };
  };
}
