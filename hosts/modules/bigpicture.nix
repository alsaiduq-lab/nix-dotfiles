{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  monitor = {
    output = "DP-1";
    width = "3440";
    height = "1440";
    refresh = "180";
  };

  gamescopeArgs = [
    "-f"
    "-O"
    monitor.output
    "-W"
    monitor.width
    "-H"
    monitor.height
    "-w"
    monitor.width
    "-h"
    monitor.height
    "-r"
    monitor.refresh
    "--backend"
    "drm"
    "--force-grab-cursor"
  ];

  patches = ''
    exec > >(${pkgs.systemd}/bin/systemd-cat -t gamescope) 2>&1

  '';

  gamescopeInit =
    pkgs.runCommand "steam-gamescope-scripts" {
      passthru.providedSessions = ["steam"];
    } ''
      mkdir -p "$out"
      cp -R ${inputs.steam-gamescope-guide}/usr/* "$out/"
      chmod -R u+w "$out"

      substituteInPlace "$out/bin/gamescope-session" --replace-fail \
          'gamescope \' \
          '${patches}${config.programs.gamescope.package}/bin/gamescope \'

      substituteInPlace "$out/bin/gamescope-session" --replace-fail \
          '-e -- steam -steamdeck -steamos3' \
          '${lib.escapeShellArgs gamescopeArgs} -e -- steam -steamdeck -steamos3'

      substituteInPlace "$out/share/wayland-sessions/steam.desktop" --replace-fail \
          "Exec=gamescope-session" \
          "Exec=$out/bin/gamescope-session"

      patchShebangs "$out/bin"
    '';
in {
  programs.steam.extraPackages = [gamescopeInit];

  programs.gamescope = {
    enable = true;
    # cap_sys_nice+pie breaks the Steam bubblewrap, which aborts with
    # "Unexpected capabilities but not setuid"
    capSysNice = false;
  };

  services.displayManager.sessionPackages = [gamescopeInit];
}
