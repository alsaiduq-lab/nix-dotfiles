{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python313,
  makeWrapper,
}: let
  python = python313.withPackages (ps: [
    ps.websockets
    ps.dbus-python
  ]);

  src = fetchFromGitHub {
    owner = "KangweiZhu";
    repo = "lyrics-on-panel";
    rev = "main";
    hash = "sha256-AjOfNUfw6oU13KFOGcRzAF48I1faLiWwWqcgsmBmc80=";
  };
in
  stdenvNoCC.mkDerivation {
    pname = "dms-lyrics-on-panel";
    version = "unstable";

    inherit src;

    nativeBuildInputs = [makeWrapper];

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
      maintainer = ["Cobray"];
    };
  }
