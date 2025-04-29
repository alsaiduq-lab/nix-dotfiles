{pkgs, ...}: let
  unstablePkgs = import (fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz")
  {system = pkgs.system;};
in {
  nixpkgs.overlays = [
    (final: prev: {
      ollama = unstablePkgs.ollama;
    })
  ];

  systemd.services.ollama = {
    description = "Ollama";
    after = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.ollama}/bin/ollama serve";
      Restart = "always";
      User = "ollama";
      Group = "ollama";
    };
  };

  users.users.ollama = {
    isSystemUser = true;
    group = "ollama";
  };
  users.groups.ollama = {};
}
