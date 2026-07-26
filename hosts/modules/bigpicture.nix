{
  inputs,
  lib,
  pkgs,
  ...
}: let
  output = "DP-1";
  w = 3440;
  h = 1440;
  r = 180;
  extraArgs = ["--sdr-gamut-wideness" "0"];

  gamescopeArgs =
    [
      "--steam"
      "--backend"
      "drm"
      "-O"
      output
      "-W"
      (toString w)
      "-H"
      (toString h)
      "-r"
      (toString r)
    ]
    ++ extraArgs;

  gamescopeScripts =
    (pkgs.runCommandNoCC "steam-gamescope-scripts" {} ''
            mkdir -p "$out"
            cp -R ${inputs.steam-gamescope-guide}/usr/* "$out/"
            chmod -R u+w "$out"

            substituteInPlace "$out/bin/gamescope-session" \
              --replace-fail \
                'gamescope \' \
                '${pkgs.systemd}/bin/systemctl --user restart --no-block headset-connect.service
      gamescope \'

            substituteInPlace "$out/bin/gamescope-session" \
              --replace-fail \
                '-e -- steam -steamdeck -steamos3' \
                '${lib.escapeShellArgs gamescopeArgs} -e -- steam -steamdeck -steamos3'

            substituteInPlace "$out/share/wayland-sessions/steam.desktop" \
              --replace-fail \
                "Exec=gamescope-session" \
                "Exec=$out/bin/gamescope-session"

            patchShebangs "$out/bin"
    '')
    .overrideAttrs (_: {
      passthru.providedSessions = ["steam"];
    });
in {
  programs.steam.extraPackages = [gamescopeScripts];

  programs.gamescope = {
    enable = true;
    # cap_sys_nice+pie breaks the Steam bubblewrap, which aborts with
    # "Unexpected capabilities but not setuid"
    capSysNice = false;
  };

  services.displayManager.sessionPackages = [gamescopeScripts];
}
