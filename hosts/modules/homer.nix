{settings, ...}: {
  services.homer = {
    enable = true;

    virtualHost = {
      nginx.enable = true;
      domain = settings.domain;
    };

    settings = {
      title = settings.domain;
      documentTitle = settings.domain;
      # subtitle = "why are you here";
      icon = "fas fa-home";
      footer = false;

      message = {
        style = "is-info";
        title = "My website.";
        icon = "fas fa-info-circle";
        content = "Placeholder; working on a better home page™";
      };

      services = [
        {
          name = "Links";
          icon = "fas fa-link";

          items = [
            {
              name = "Git";
              icon = "fas fa-code-branch";
              # subtitle = "stuff";
              url = "https://git.${settings.domain}";
              target = "_blank";
            }
          ];
        }
      ];
    };
  };

  services.nginx.virtualHosts."${settings.domain}" = {
    forceSSL = true;
    enableACME = true;

    locations."/".extraConfig = ''
      add_header X-Robots-Tag "noindex, nofollow" always;
    '';
  };
}
