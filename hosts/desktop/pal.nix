# mostly based on https://gist.github.com/al3xtjames/045f7ccccccecffa6756e033c13df859
{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  serverName = "Pals";
  port = 8211;
  players = 8;
  openFirewall = true;
  autoStart = false;
  adminPasswordSecret = "palworld/admin";
  serverPasswordSecret = "palworld/join";

  settings = {
    ExpRate = 1.5;
    PalEggDefaultHatchingTime = 60.0;
    DeathPenalty = "Item";
  };

  toUE = v:
    if lib.isBool v
    then
      (
        if v
        then "True"
        else "False"
      )
    else if lib.isList v
    then "(${lib.concatStringsSep "," v})"
    else if lib.isString v
    then ''"${v}"''
    else toString v;
in {
  imports = [inputs.sops-nix.nixosModules.sops];

  # Based on https://kevincox.ca/2022/12/09/valheim-server-nixos-v2/
  users.users.palworld = {
    isSystemUser = true;
    home = "/var/lib/palworld";
    createHome = true;
    homeMode = "750";
    group = "palworld";
  };

  users.groups.palworld = {};

  networking.firewall.allowedUDPPorts = lib.optionals openFirewall [port];

  sops.secrets.${adminPasswordSecret} = {};
  sops.secrets.${serverPasswordSecret} = {};

  sops.templates."PalWorldSettings.ini" = {
    owner = "palworld";
    restartUnits = ["palworld-server.service"];
    content = lib.generators.toINI {} {
      "/Script/Pal.PalGameWorldSettings".OptionSettings = "(${lib.concatStringsSep "," (lib.mapAttrsToList (k: v: "${k}=${toUE v}") (
        settings
        // {
          ServerName = serverName;
          AdminPassword = config.sops.placeholder.${adminPasswordSecret};
          ServerPassword = config.sops.placeholder.${serverPasswordSecret};
        }
      ))})";
    };
  };

  systemd.services.palworld-server = {
    description = "Palworld Dedicated Server";
    wants = ["network-online.target"];
    after = ["network-online.target"];
    wantedBy = lib.optionals autoStart ["multi-user.target"];

    serviceConfig = {
      ExecStartPre = pkgs.writeShellScript "update-palworld-server.sh" ''
        ${lib.getExe pkgs.steamcmd} +force_install_dir ~ +login anonymous \
          +app_update 2394010 validate +quit

        mkdir -p .steam/sdk64
        ln -f -s ../../linux64/steamclient.so .steam/sdk64/steamclient.so

        mkdir -p Pal/Saved/Config/LinuxServer
        install -m 640 ${config.sops.templates."PalWorldSettings.ini".path} Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
      '';

      ExecStart = lib.escapeShellArgs [
        (lib.getExe pkgs.steam-run)
        "/var/lib/palworld/PalServer.sh"
        "-port=${toString port}"
        "-players=${toString players}"
        "-useperfthreads"
        "-NoAsyncLoadingThread"
        "-UseMultithreadForDS"
      ];

      Restart = "on-failure";
      RestartSec = 30;
      User = "palworld";
      WorkingDirectory = "~";
      TimeoutStartSec = 1800; # Allow time for the first download.

      # Hardening options
      CapabilityBoundingSet = [""];
      LockPersonality = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateIPC = true;
      PrivateTmp = true;
      PrivateUsers = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "full";
      RemoveIPC = true;
      RestrictAddressFamilies = ["AF_INET" "AF_INET6"];
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };
  };
}
