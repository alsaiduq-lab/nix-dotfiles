{pkgs, ...}: {
  services.searx = {
    enable = true;
    environmentFile = "/var/lib/searx/searxng.env";
    settings = {
      server = {
        bind_address = "127.0.0.1";
        port = 6767;
        limiter = false;
        image_proxy = true;
        secret_key = "$SEARXNG_SECRET";
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
      outgoing = {
        request_timeout = 4.0;
        max_request_timeout = 8.0;
      };
      engines = [
        {
          name = "bing";
          disabled = false;
        }
      ];
      plugins = {
        "searx.plugins.calculator.SXNGPlugin".active = true;
        "searx.plugins.infinite_scroll.SXNGPlugin".active = true;
        "searx.plugins.hash_plugin.SXNGPlugin".active = true;
        "searx.plugins.self_info.SXNGPlugin".active = true;
        "searx.plugins.unit_converter.SXNGPlugin".active = true;
        "searx.plugins.ahmia_filter.SXNGPlugin".active = true;
        "searx.plugins.hostnames.SXNGPlugin".active = true;
        "searx.plugins.time_zone.SXNGPlugin".active = true;
        "searx.plugins.oa_doi_rewrite.SXNGPlugin".active = true;
        "searx.plugins.tracker_url_remover.SXNGPlugin".active = true;
      };
    };
  };

  systemd.services.searx-secret = {
    description = "Generate SearXNG secret";
    requiredBy = ["searx-init.service"];
    before = ["searx-init.service"];
    serviceConfig.Type = "oneshot";
    script = ''
      install -d -m 0750 -o searx -g searx /var/lib/searx
      if [ ! -f /var/lib/searx/searxng.env ]; then
        umask 0077
        echo "SEARXNG_SECRET=$(${pkgs.openssl}/bin/openssl rand -hex 32)" > /var/lib/searx/searxng.env
        chown searx:searx /var/lib/searx/searxng.env
        chmod 0640 /var/lib/searx/searxng.env
      fi
    '';
  };
}
