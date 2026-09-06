{
  config,
  lib,
  settings,
  ...
}: {
  sops.secrets."anubis" = {
    owner = lib.mkForce "anubis";
    group = "anubis";
  };

  services.anubis = {
    defaultOptions = {
      settings = {
        COOKIE_DOMAIN = settings.domain;
        OG_PASSTHROUGH = true;
        OG_EXPIRY_TIME = "24h";
        COOKIE_EXPIRATION_TIME = "30m";
        SERVE_ROBOTS_TXT = true;
        DIFFICULTY = 5;
      };
      policy = {
        useDefaultBotRules = true;
        extraBots = [
          {
            name = "uptime";
            user_agent_regex = "Uptime-Kuma";
            action = "ALLOW";
          }
          {
            name = "discordbot";
            user_agent_regex = "^Mozilla/5[.]0 [(]compatible; Discordbot/2[.]0; [+]https://discordapp[.]com[)]$";
            action = "ALLOW";
          }
        ];
      };
    };
    instances = {
      forgejo = {
        settings = {
          TARGET = "http://${config.services.forgejo.settings.server.HTTP_ADDR}:${toString config.services.forgejo.settings.server.HTTP_PORT}";
          ED25519_PRIVATE_KEY_HEX_FILE = config.sops.secrets."anubis".path;
        };
      };
      copyparty = {
        settings = {
          TARGET = "http://${config.services.copyparty.settings.i}:${toString (builtins.head config.services.copyparty.settings.p)}";
          ED25519_PRIVATE_KEY_HEX_FILE = config.sops.secrets."anubis".path;
        };
      };
    };
  };

  users.users.nginx.extraGroups = ["anubis"];
}
