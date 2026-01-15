{
  pkgs,
  inputs,
  lib,
  ...
}: {
  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
    enableSystemMonitoring = true;
    enableVPN = false;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;

    plugins = {
      lyricsOnPanel = {
        src = "${pkgs.dms-plugins.lyrics-on-panel}/plugin";
      };
    };

    quickshell.package = pkgs.quickshell;
  };

  programs.nix-monitor = {
    enable = true;
    rebuildCommand = [
      "bash"
      "-c"
      "cd ~/nix && nix flake update && sudo pixos-rebuild switch --flake ~/nix 2>&1"
    ];
    gcCommand = [
      "bash"
      "-c"
      "sudo pix-collect-garbage -d 2>&1"
    ];
    generationsCommand = ["bash" "-c" "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | wc -l"];
    updateInterval = 1800;
    localRevisionCommand = ["bash" "-c" "echo 0"];
    remoteRevisionCommand = [
      "${pkgs.bash}/bin/bash"
      "-l"
      "-c"
      "${pkgs.curl}/bin/curl -s https://api.github.com/repos/NixOS/nixpkgs/git/ref/heads/nixos-25.11 2>/dev/null | ${pkgs.jq}/bin/jq -r '.object.sha' 2>/dev/null | cut -c 1-7 || echo 'N/A'"
    ];
    nixpkgsChannel = "nixos-25.11";
  };

  home.packages = with pkgs; [
    dms-shell
    dgop
    ddcutil
    cliphist
    kdePackages.dolphin
  ];

  home.sessionPath = ["${pkgs.quickshell}/bin"];

  systemd.user.services.lyrics-on-panel = {
    Unit = {
      Description = "Lyrics-on-Panel MPRIS2 Backend";
      After = ["graphical-session.target"];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.dms-plugins.lyrics-on-panel}/bin/lyrics-on-panel-backend";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
