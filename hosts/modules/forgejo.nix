{settings, ...}: {
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;
    dump.enable = true;
    settings = {
      server = {
        DOMAIN = "git.${settings.domain}";
        ROOT_URL = "https://git.${settings.domain}/";
        HTTP_ADDR = "127.0.0.1";
        SSH_DOMAIN = "git.${settings.domain}";
        LANDING_PAGE = "/alteur";
      };
      service.DISABLE_REGISTRATION = true;
      openid.ENABLE_OPENID_SIGNIN = false;
      ui.SHOW_USER_EMAIL = false;
      "cron.git_gc_repos".ENABLED = true;
      repository = {
        ENABLE_PUSH_CREATE_USER = true;
        DEFAULT_BRANCH = "master";
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
      "git.timeout" = {
        MIGRATE = 6000;
        MIRROR = 3600;
      };

      log.LEVEL = "Warn";
      actions.ENABLED = true;
    };
  };

  systemd.services.forgejo = {
    requires = ["redis-forgejo.service"];
    after = ["redis-forgejo.service"];
  };

  services.redis.servers.forgejo = {
    enable = true;
    port = 0;
    unixSocket = "/run/redis-forgejo/redis.sock";
    unixSocketPerm = 660;
  };

  users.users.forgejo.extraGroups = ["redis-forgejo"];

  services.nginx.virtualHosts."git.${settings.domain}" = {
    forceSSL = true;
    enableACME = true;
    extraConfig = "client_max_body_size 0M;";
    locations."/" = {
      proxyPass = "http://unix:/run/anubis/anubis-forgejo/anubis.sock";
      proxyWebsockets = true;
    };
  };
}
