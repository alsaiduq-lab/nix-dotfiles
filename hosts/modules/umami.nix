{
  config,
  pkgs,
  ...
}: {
  sops.secrets."umami" = {
    owner = "umami";
  };

  services.postgresql = {
    ensureDatabases = ["umami"];
    ensureUsers = [
      {
        name = "umami";
        ensureDBOwnership = true;
      }
    ];
  };

  users.users.umami = {
    isSystemUser = true;
    group = "umami";
    home = "/var/lib/umami";
    createHome = true;
  };
  users.groups.umami = {};

  systemd.services.umami = {
    description = "Umami";
    after = ["network.target" "postgresql.service"];
    requires = ["postgresql.service"];
    wantedBy = ["multi-user.target"];

    preStart = ''
      APP_SECRET=$(cat ${config.sops.secrets."umami".path})
      printf 'APP_SECRET=%s\n' "$APP_SECRET" > /var/lib/umami/.env
      chmod 600 /var/lib/umami/.env
    '';

    environment = {
      DATABASE_URL = "postgresql://umami:@/umami?host=/run/postgresql";
      HOSTNAME = "127.0.0.1";
      DISABLE_TELEMETRY = "1";
    };

    serviceConfig = {
      Type = "simple";
      User = "umami";
      Group = "umami";
      WorkingDirectory = "${pkgs.umami}";
      EnvironmentFile = "/var/lib/umami/.env";
      ExecStart = "${pkgs.umami}/bin/umami-server";
      Restart = "on-failure";
      RestartSec = 5;
      StateDirectory = "umami";

      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ReadWritePaths = ["/var/lib/umami"];
      PrivateTmp = true;
      PrivateDevices = true;
    };
  };

  services.nginx.virtualHosts."analytics.monaie.ca" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3600";
      proxyWebsockets = true;
    };
  };
}
