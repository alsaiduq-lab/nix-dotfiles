{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    autossh
  ];

  systemd.services.autossh-redbot = {
    description = "Persistent SSH Tunnel to server";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "cobray";
      Group = "cobray";
      Restart = "always";
      RestartSec = 30;
      EnvironmentFile = "/home/cobray/.secrets/autossh-redbot.conf";
      Environment = [
        "AUTOSSH_GATETIME=0"
        "AUTOSSH_POLL=60"
        "AUTOSSH_FIRST_POLL=30"
        "AUTOSSH_PORT=0"
      ];
      ExecStart = ''
        ${pkgs.autossh}/bin/autossh -M 0 -N \
          -o "ServerAliveInterval 60" \
          -o "ServerAliveCountMax 3" \
          -o "ExitOnForwardFailure=yes" \
          -o "ConnectTimeout=10" \
          -R "0.0.0.0:$REMOTE_PORT:localhost:$LOCAL_PORT" \
          root@$REMOTE_HOST
      '';
    };
  };
}
