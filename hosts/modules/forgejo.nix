{config, ...}: {
  services.postgresql = {
    enable = true;
    ensureDatabases = ["forgejo"];
    ensureUsers = [
      {
        name = "forgejo";
        ensureDBOwnership = true;
      }
    ];
  };

  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = "git.${config.server.hostname}";
        ROOT_URL = "https://git.${config.server.hostname}/";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;
        SSH_DOMAIN = "git.${config.server.hostname}";
      };
      service = {
        DISABLE_REGISTRATION = true;
        REQUIRE_SIGNIN_VIEW = false;
      };
      session = {
        PROVIDER = "redis";
        PROVIDER_CONFIG = "network=unix,addr=/run/redis-forgejo/redis.sock,db=0,pool_size=100,idle_timeout=180";
      };
      cache = {
        ADAPTER = "redis";
        HOST = "network=unix,addr=/run/redis-forgejo/redis.sock,db=1,pool_size=100,idle_timeout=180";
      };
      queue = {
        TYPE = "redis";
        CONN_STR = "network=unix,addr=/run/redis-forgejo/redis.sock,db=2";
      };
      log.LEVEL = "Warn";
      security.INSTALL_LOCK = true;
      actions.ENABLED = true;
    };
  };

  services.redis.servers.forgejo = {
    enable = true;
    port = 0;
    unixSocket = "/run/redis-forgejo/redis.sock";
    unixSocketPerm = 660;
  };

  users.users.forgejo.extraGroups = ["redis-forgejo"];

  services.nginx.virtualHosts."git.${config.server.hostname}" = {
    forceSSL = true;
    enableACME = true;
    extraConfig = "client_max_body_size 0M;";
    locations."/" = {
      proxyPass = "http://unix:/run/anubis/anubis-forgejo/anubis.sock";
      proxyWebsockets = true;
    };
  };
}
