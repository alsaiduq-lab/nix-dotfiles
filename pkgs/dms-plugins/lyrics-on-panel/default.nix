{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python313,
  makeWrapper,
  updateDeps,
}: let
  pname = "dms-lyrics-on-panel";
  version = "unstable";
  deps = builtins.fromJSON (builtins.readFile ./deps.json);
  source = {
    owner = "KangweiZhu";
    repo = "lyrics-on-panel";
    rev = "main";
  };

  python = python313.withPackages (ps: [
    ps.websockets
    ps.dbus-python
  ]);

  src = fetchFromGitHub (source // {
    hash = deps.src.hash;
  });
in
  stdenvNoCC.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = [makeWrapper];

    passthru = {
      depsFile = "pkgs/dms-plugins/lyrics-on-panel/deps.json";
      "update-deps" = updateDeps.fetchFromGitHub (source // {
        name = pname;
      });
    };

    dontBuild = true;

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
