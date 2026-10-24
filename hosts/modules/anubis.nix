{
  config,
  lib,
  settings,
  inputs,
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
        COOKIE_EXPIRATION_TIME = "30m";
        SERVE_ROBOTS_TXT = true;
        DIFFICULTY = 4;
      };
      policy = {
        useDefaultBotRules = true;
        extraBots = [
          {
            import = "(data)/clients/git.yaml";
          }
          {
            name = "uptime";
            action = "ALLOW";
            user_agent_regex = "Uptime-Kuma";
            remote_addresses =
              map (ip: "${ip.address}/32")
              config.networking.interfaces.enX0.ipv4.addresses;
          }
          {
            name = "discord";
            action = "ALLOW";
            remote_addresses =
              map (prefix: prefix.ipv4Prefix)
              (builtins.fromJSON (builtins.readFile inputs.discord-ips)).prefixes;
          }
          {
            name = "nix-exclude";
            action = "ALLOW";
            expression.all = [
              ''userAgent.contains("Nix/")''
              ''path.matches("^/[^/]+/[^/]+/archive/")''
            ];
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
