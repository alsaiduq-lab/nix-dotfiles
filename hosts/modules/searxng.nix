{
  pkgs,
  lib,
  ...
}: let
  domain = null;
  acmeEmail = null;
  envFile = "/var/lib/searx/searxng.env";
in {
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    redisCreateLocally = true;
    environmentFile = envFile;
    configureUwsgi = false;
    settings = {
      server = {
        bind_address = "127.0.0.1";
        port = 11212;
        limiter = false;
        image_proxy = true;
        base_url = lib.mkIf (domain != null) "https://${domain}";
      };
      ui = {
        default_locale = "en";
        default_theme = "simple";
      };
      search = {
        safe_search = 0;
        autocomplete = "duckduckgo";
        formats = ["html" "json"];
      };
      enabled_plugins = [
        "hash"
        "self_info"
        "tracker_url_remover"
        "hostname_replace"
        "open_access_doi_rewrite"
      ];
    };
    limiterSettings.real_ip = {
      x_for = 1;
      ipv4_prefix = 32;
      ipv6_prefix = 56;
    };
  };
  systemd.services.searx-secret = {
    description = "Generate SearXNG secret";
    wantedBy = ["multi-user.target"];
    before = ["searx-init.service" "searx.service"];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Group = "root";
    };
    script = ''
      set -euo pipefail
      install -d -m 0750 -o searx -g searx /var/lib/searx
      if [ ! -f ${envFile} ]; then
        umask 0077
        echo "SEARXNG_SECRET=$(${pkgs.openssl}/bin/openssl rand -hex 32)" > ${envFile}
        chown searx:searx ${envFile}
        chmod 0640 ${envFile}
      fi
    '';
  };
  systemd.services.searx-init = {
    wants = ["searx-secret.service"];
    after = ["searx-secret.service"];
  };
  systemd.services.searx = {
    wants = ["searx-secret.service"];
    after = ["searx-secret.service"];
  };
  users.groups.searx.members = ["nginx"];
  security.acme = lib.mkIf (domain != null) {
    acceptTerms = true;
    defaults = lib.mkIf (acmeEmail != null) {email = acmeEmail;};
  };
}
