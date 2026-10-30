{
  config,
  settings,
  ...
}: {
  sops.secrets.ntfy = {};
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://ntfy.${settings.domain}";
      listen-http = "127.0.0.1:2586";
      behind-proxy = true;
      auth-default-access = "deny-all";
      auth-file = "/var/lib/ntfy-sh/user.db";
    };
  };

  systemd.services.ntfy-sh = {
    serviceConfig.LoadCredential = "ntfy-password:${config.sops.secrets.ntfy.path}";
    preStart = ''
      if ! ${config.services.ntfy-sh.package}/bin/ntfy user list | grep -q kuma; then
        NTFY_PASSWORD=$(cat "$CREDENTIALS_DIRECTORY/ntfy-password") ${config.services.ntfy-sh.package}/bin/ntfy user add --ignore-exists kuma
        ${config.services.ntfy-sh.package}/bin/ntfy access kuma "alerts" rw
      fi
    '';
  };

  services.nginx.virtualHosts."ntfy.${settings.domain}" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:2586";
      proxyWebsockets = true;
    };
  };
}
