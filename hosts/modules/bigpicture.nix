{
  inputs,
  lib,
  pkgs,
  ...
}: let
  gamescopeArgs = [
    "-f"
    "--backend"
    "drm"
    "--sdr-gamut-wideness"
    "0"
    "--prefer-output"
    "DP-1,HDMI-A-1,DP-2"
    "--force-grab-cursor"
  ];

  patches = ''
    '${pkgs.systemd}/bin/systemctl --user restart --no-block headset-connect.service

  '';

  gamescopeInit =
    (pkgs.runCommand "steam-gamescope-scripts" {} ''
      mkdir -p "$out"
      cp -R ${inputs.steam-gamescope-guide}/usr/* "$out/"
      chmod -R u+w "$out"

      substituteInPlace "$out/bin/gamescope-session" --replace-fail \
          'gamescope \' \
          ${patches}
          gamescope \'

      substituteInPlace "$out/bin/gamescope-session" --replace-fail \
          '-e -- steam -steamdeck -steamos3' \
          '${lib.escapeShellArgs gamescopeArgs} -e -- steam -steamdeck -steamos3'

      substituteInPlace "$out/share/wayland-sessions/steam.desktop" --replace-fail \
          "Exec=gamescope-session" \
          "Exec=$out/bin/gamescope-session"

      patchShebangs "$out/bin"
    '')
    .overrideAttrs (_: {
      passthru.providedSessions = ["steam"];
    });
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
