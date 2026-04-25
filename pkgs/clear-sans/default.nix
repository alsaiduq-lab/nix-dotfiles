{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  updateDeps,
}: let
  pname = "clear-sans";
  version = "1.0";
  deps = builtins.fromJSON (builtins.readFile ./deps.json);
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "intel";
      repo = "clear-sans";
      rev = "main";
      hash = deps.src.hash;
    };

    passthru = {
      depsFile = "pkgs/clear-sans/deps.json";
      "update-deps" = updateDeps.fetchFromGitHub {
        name = pname;
        owner = "intel";
        repo = "clear-sans";
        rev = "main";
      };
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
