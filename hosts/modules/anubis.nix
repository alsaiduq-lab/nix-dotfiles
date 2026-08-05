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
        COOKIE_EXPIRATION_TIME = "24h";
        SERVE_ROBOTS_TXT = true;
        DIFFICULTY = 3;
      };
      policy = {
        useDefaultBotRules = false;
        extraBots = [
          {
            name = "forgejo-assets";
            path_regex = "^/assets/.*$";
            action = "ALLOW";
          }
          {
            name = "forgejo-manifest";
            path_regex = "^/manifest.json$";
            action = "ALLOW";
          }
          {
            name = "favicon";
            path_regex = "^/favicon.ico$";
            action = "ALLOW";
          }
          {
            name = "robots-txt";
            path_regex = "^/robots.txt$";
            action = "ALLOW";
          }
          {
            name = "well-known";
            path_regex = "^/.well-known/.*$";
            action = "ALLOW";
          }
          {
            name = "uptime";
            user_agent_regex = "(?i)(uptime-kuma|uptimerobot|updown\\.io)";
            action = "ALLOW";
          }
          {
            name = "discordbot";
            user_agent_regex = "(?i)discordbot";
            action = "ALLOW";
          }
          # holy shit go fuck yourself meta
          {
            name = "meta-webindexer";
            user_agent_regex = "(?i)meta-webindexer";
            action = "DENY";
          }
          {
            name = "ai-crawlers";
            user_agent_regex = "(?i)(claudebot|gptbot|chatgpt-user|oai-searchbot|google-extended|bytespider|amazonbot|meta-externalagent|ccbot|perplexitybot|cohere-ai|diffbot|omgili|imagesift)";
            action = "DENY";
          }
          {
            name = "generic-browser";
            user_agent_regex = "Mozilla";
            action = "CHALLENGE";
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
