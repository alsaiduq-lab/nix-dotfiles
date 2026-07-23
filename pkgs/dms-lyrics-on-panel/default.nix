{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python313,
  makeWrapper,
}: let
  pname = "dms-lyrics-on-panel";
  source = (import ../sources.nix).dms-lyrics-on-panel;
  inherit (source) version;
  deps = builtins.fromJSON (builtins.readFile ./deps.json);
  python = python313.withPackages (ps: [
    ps.websockets
    ps.dbus-python
  ]);
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      inherit (source) owner repo rev;
      hash = deps.src.hash;
    };

    strictDeps = true;
    dontBuild = true;

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/plugin $out/bin
      cp -r dms/* $out/plugin/
      cp -r backend/src $out/backend

      makeWrapper ${python}/bin/python $out/bin/lyrics-on-panel-backend \
        --add-flags "$out/backend/server.py"

      runHook postInstall
    '';

    meta = {
      description = "Lyrics on Panel - DMS plugin and backend";
      homepage = "https://github.com/KangweiZhu/lyrics-on-panel";
      license = lib.licenses.gpl3;
      maintainers = ["Hibiki"];
    };
  }
