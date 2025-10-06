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
    runInUwsgi = false;
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
        default_engine = "";
        default_categories = ["general" "it" "images" "videos" "map" "news" "science"];
        formats = ["html" "json"];
      };
      enabled_plugins = [
        "hash"
        "self_info"
        "tracker_url_remover"
        "hostname_replace"
        "open_access_doi_rewrite"
      ];
      engines = [
        {
          name = "duckduckgo_web";
          engine = "duckduckgo";
          disabled = false;
          categories = ["general"];
          weight = 1.0;
          timeout = 3.0;
        }
        {
          name = "google_web";
          engine = "google";
          disabled = false;
          categories = ["general"];
          weight = 1.0;
          timeout = 4.0;
        }
        {
          name = "bing_web";
          engine = "bing";
          disabled = false;
          categories = ["general"];
          weight = 1.0;
          timeout = 4.0;
        }
        {
          name = "brave";
          engine = "brave";
          disabled = false;
          categories = ["general"];
          weight = 1.0;
          timeout = 3.0;
        }
        {
          name = "mojeek";
          engine = "mojeek";
          disabled = false;
          categories = ["general"];
          weight = 0.9;
          timeout = 3.0;
        }
        {
          name = "qwant";
          engine = "qwant";
          disabled = false;
          categories = ["general"];
          weight = 0.8;
          timeout = 3.0;
        }
        {
          name = "startpage";
          engine = "startpage";
          disabled = false;
          categories = ["general"];
          weight = 0.9;
          timeout = 4.0;
        }
        {
          name = "wikipedia";
          engine = "wikipedia";
          disabled = false;
          categories = ["general"];
          timeout = 3.0;
        }
        {
          name = "wikidata";
          engine = "wikidata";
          disabled = false;
          categories = ["general"];
          timeout = 3.0;
        }
        {
          name = "wikibooks";
          engine = "wikibooks";
          disabled = false;
          categories = ["general"];
          timeout = 3.0;
        }
        {
          name = "wiktionary";
          engine = "wiktionary";
          disabled = false;
          categories = ["general"];
          timeout = 3.0;
        }
        {
          name = "arxiv";
          engine = "arxiv";
          disabled = false;
          categories = ["science"];
          timeout = 4.0;
        }
        {
          name = "crossref";
          engine = "crossref";
          disabled = false;
          categories = ["science"];
          timeout = 4.0;
        }
        {
          name = "semantic_scholar";
          engine = "semantic_scholar";
          disabled = false;
          categories = ["science"];
          timeout = 4.0;
        }
        {
          name = "github_code";
          engine = "github";
          disabled = false;
          categories = ["it"];
          timeout = 4.0;
        }
        {
          name = "stackoverflow";
          engine = "stackoverflow";
          disabled = false;
          categories = ["it"];
          timeout = 4.0;
        }
        {
          name = "wikicommons_img";
          engine = "wikicommons";
          disabled = false;
          categories = ["images"];
          timeout = 4.0;
        }
        {
          name = "youtube_video";
          engine = "youtube";
          disabled = false;
          categories = ["videos"];
          timeout = 5.0;
        }
        {
          name = "peertube_video";
          engine = "peertube";
          disabled = false;
          categories = ["videos"];
          timeout = 5.0;
        }
        {
          name = "openstreetmap";
          engine = "openstreetmap";
          disabled = false;
          categories = ["map"];
          timeout = 4.0;
        }
        {
          name = "google_maps";
          engine = "google_maps";
          disabled = false;
          categories = ["map"];
          timeout = 4.0;
        }
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
