{
  fetchFromGitHub,
  lib,
  python3,
  qt6,
}: let
  source = (import ../sources.nix).linux-arctis-manager;
  deps = builtins.fromJSON (builtins.readFile ./deps.json);
in
  python3.pkgs.buildPythonApplication {
    pname = "linux-arctis-manager";
    inherit (source) version;

    pyproject = true;

    src = fetchFromGitHub {
      inherit (source) owner repo rev;
      hash = deps.src.hash;
    };

    strictDeps = true;

    build-system = [
      python3.pkgs.uv-build
    ];

    dependencies = with python3.pkgs; [
      dbus-next
      pulsectl
      pyside6
      pyudev
      pyusb
      ruamel-yaml
    ];

    nativeBuildInputs = [
      qt6.wrapQtAppsHook
    ];

    buildInputs = [
      qt6.qtwayland
    ];

    dontWrapQtApps = true;

    postInstall = ''
      install -Dm644 \
        src/linux_arctis_manager/desktop/ArctisManager.desktop \
        $out/share/applications/ArctisManager.desktop

      install -Dm644 \
        src/linux_arctis_manager/desktop/ArctisManagerSystray.desktop \
        $out/share/applications/ArctisManagerSystray.desktop

      install -Dm644 \
        src/linux_arctis_manager/gui/images/steelseries_logo.svg \
        $out/share/icons/hicolor/scalable/apps/arctis-manager.svg

      substituteInPlace $out/share/applications/ArctisManager.desktop \
        --replace-fail \
          "Exec=/bin/sh -c 'exec lam-gui >/dev/null 2>&1'" \
          "Exec=$out/bin/lam-gui --no-enforce-systemd"

      substituteInPlace $out/share/applications/ArctisManagerSystray.desktop \
        --replace-fail \
          "Exec=/bin/sh -c 'exec lam-gui --systray >/dev/null 2>&1'" \
          "Exec=$out/bin/lam-gui --systray --no-enforce-systemd"
    '';

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail \
          'uv_build>=0.10.9,<0.11.0' \
          'uv_build>=0.10.9,<0.12.0'
    '';

    preFixup = ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    '';

    postFixup = ''
      HOME="$TMPDIR" $out/bin/lam-cli udev write-rules \
        --rules-path $out/lib/udev/rules.d/91-steelseries-arctis.rules \
        --create-directories
    '';

    pythonImportsCheck = [
      "linux_arctis_manager"
    ];

    meta = {
      description = "SteelSeries GG manager for Arctis headsets for linux";
      homepage = "https://github.com/elegos/Linux-Arctis-Manager";
      license = lib.licenses.gpl3Only;
      mainProgram = "lam-gui";
      platforms = lib.platforms.linux;
    };
  }
