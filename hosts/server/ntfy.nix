{config, ...}: {
  sops.secrets."ntfy" = {
    owner = "ntfy-sh";
  };
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://ntfy.monaie.ca";
      listen-http = "127.0.0.1:2586";
      behind-proxy = true;
      auth-default-access = "deny-all";
      auth-file = "/var/lib/ntfy-sh/user.db";
    };
  };

  systemd.services.ntfy-sh.preStart = ''
    if ! ${config.services.ntfy-sh.package}/bin/ntfy user list | grep -q kuma; then
      NTFY_PASSWORD=$(cat ${config.sops.secrets."ntfy".path}) ${config.services.ntfy-sh.package}/bin/ntfy user add --ignore-exists kuma
      ${config.services.ntfy-sh.package}/bin/ntfy access kuma "alerts" rw
    fi
  '';

  services.nginx.virtualHosts."ntfy.monaie.ca" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:2586";
      proxyWebsockets = true;
    };
  };
}
