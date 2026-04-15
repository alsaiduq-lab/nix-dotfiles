{...}: let
  domain = "git.monaie.ca";
  port = 3000;
in {
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
        DOMAIN = domain;
        ROOT_URL = "https://${domain}/";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = port;
        SSH_DOMAIN = domain;
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
      actions.ENABLED = false;
    };
  };

  services.redis.servers.forgejo = {
    enable = true;
    port = 0;
    unixSocket = "/run/redis-forgejo/redis.sock";
    unixSocketPerm = 660;
  };
  users.users.forgejo.extraGroups = ["redis-forgejo"];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    commonHttpConfig = ''
      set_real_ip_from 173.245.48.0/20;
      set_real_ip_from 103.21.244.0/22;
      set_real_ip_from 103.22.200.0/22;
      set_real_ip_from 103.31.4.0/22;
      set_real_ip_from 141.101.64.0/18;
      set_real_ip_from 108.162.192.0/18;
      set_real_ip_from 190.93.240.0/20;
      set_real_ip_from 188.114.96.0/20;
      set_real_ip_from 197.234.240.0/22;
      set_real_ip_from 198.41.128.0/17;
      set_real_ip_from 162.158.0.0/15;
      set_real_ip_from 104.16.0.0/13;
      set_real_ip_from 104.24.0.0/14;
      set_real_ip_from 172.64.0.0/13;
      set_real_ip_from 131.0.72.0/22;
      real_ip_header CF-Connecting-IP;
    '';
    virtualHosts."_" = {
      default = true;
      rejectSSL = true;
      locations."/" = {
        return = "444";
      };
    };
    virtualHosts.${domain} = {
      forceSSL = true;
      enableACME = true;
      extraConfig = "client_max_body_size 0M;";
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true;
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "riiidge.racer@gmail.com";
  };
}
