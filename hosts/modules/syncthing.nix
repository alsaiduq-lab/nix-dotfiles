{config, ...}: let
  magus = config.networking.hostName == "magus";
  user =
    if magus
    then "alteur"
    else config.theme.user;
in {
  services.syncthing = {
    enable = true;
    inherit user;
    key = config.sops.secrets."syncthing/${config.networking.hostName}/key".path;
    cert = config.sops.secrets."syncthing/${config.networking.hostName}/cert".path;
    settings = {
      devices = {
        nixos.id = "ICSAKM2-UGV7G7C-6Y2UNVJ-PIW3GIL-CU36BQL-OMAAJIO-XBMFTUA-IQZENQU";
        magus.id = "MBQZZB2-5R2DCIK-SWRVNHS-XQL7LWY-ZYMJOYS-EE4OYCB-HAMDLRM-W6FB2AC";
      };
      folders."nix" = {
        path = "/home/${user}/nix";
        devices = [
          (
            if magus
            then "nixos"
            else "magus"
          )
        ];
        type =
          if magus
          then "receiveonly"
          else "sendreceive";
      };
    };
  };

  sops.secrets."syncthing/${config.networking.hostName}/key" = {
    owner = user;
  };
  sops.secrets."syncthing/${config.networking.hostName}/cert" = {
    owner = user;
  };
}
