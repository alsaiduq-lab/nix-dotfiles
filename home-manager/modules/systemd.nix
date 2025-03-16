{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [ autossh ];

  systemd.user.services.autossh-redbot = {
    unitConfig = {
      Description = "Persistent SSH Tunnel to server";
      WantedBy = "default.target";
    };
    serviceConfig = {
      Restart = "always";
      RestartSec = "30";
      EnvironmentFile = "/home/cobray/nix/.secrets/autossh-redbot.conf";
      Environment = [
        "AUTOSSH_GATETIME=0"
        "AUTOSSH_POLL=60"
        "AUTOSSH_FIRST_POLL=30"
        "AUTOSSH_PORT=0"
      ];
      ExecStart = ''
        /nix/store/abc123-autossh-1.4g/bin/autossh -M 0 -N \
          -o "ServerAliveInterval 60" \
          -o "ServerAliveCountMax 3" \
          -o "ExitOnForwardFailure=yes" \
          -o "ConnectTimeout=10" \
          -R "0.0.0.0:2222:localhost:22" \
          root@your-real-host.com
      '';
    };
  };
}
