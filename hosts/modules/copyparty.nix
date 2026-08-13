{
  config,
  settings,
  ...
}: {
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
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
      og = true;
      og-title = "share.${settings.domain}";
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
  # prevents a race condition error when initializing w/ secrets from sops
  systemd.services.copyparty = {
    requires = ["sops-install-secrets.service"];
    after = ["sops-install-secrets.service"];
  };
  systemd.tmpfiles.rules = [
    "d /srv/copyparty 0750 copyparty copyparty -"
  ];
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."share.${settings.domain}" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://unix:/run/anubis/anubis-copyparty/anubis.sock";
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
