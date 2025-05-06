{pkgs, ...}: let
  unstablePkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    sha256 = "0h8dhnw8j9ngxcj6wpyr8k1kx2jvwl4n5y2rk9ji7gv3iza4dspg";
  }) {system = pkgs.system;};
in {
  nixpkgs.overlays = [
    (final: prev: {ollama = unstablePkgs.ollama;})
  ];

  environment.systemPackages = [pkgs.ollama];

  systemd.services.ollama = {
    description = "Ollama";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      StateDirectory = "ollama"; # /var/lib/ollama
      WorkingDirectory = "%S/ollama";
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
