{...}: {
  services.filebrowser = {
    enable = true;
    settings = {
      address = "127.0.0.1";
      port = 6767;
      root = "/srv/filebrowser";
      database = "/var/lib/filebrowser/filebrowser.db";
    };
  };

  systemd.tmpfiles.rules = [
    "d /srv/filebrowser 0750 filebrowser filebrowser -"
  ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."share.monaie.ca" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:6767";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 0;
        '';
      };
    };
  };
}
