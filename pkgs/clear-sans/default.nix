{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  updateDeps,
}: let
  pname = "clear-sans";
  version = "1.0";
  deps = builtins.fromJSON (builtins.readFile ./deps.json);
  source = {
    owner = "intel";
    repo = "clear-sans";
    rev = "main";
  };
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub (source // {
      hash = deps.src.hash;
    });

    passthru = {
      depsFile = "pkgs/clear-sans/deps.json";
      "update-deps" = updateDeps.fetchFromGitHub (source // {
        name = pname;
      });
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/fonts/truetype
      cp TTF/*.ttf $out/share/fonts/truetype/

      runHook postInstall
    '';

    meta = {
      description = "Clear Sans font";
      homepage = "https://github.com/intel/clear-sans";
      license = lib.licenses.asl20;
      maintainers = ["Hibiki"];
      platforms = lib.platforms.all;
    };
  }
