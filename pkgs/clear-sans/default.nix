{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}: let
  pname = "clear-sans";
  source = (import ../sources.nix).clear-sans;
  inherit (source) version;
  deps = builtins.fromJSON (builtins.readFile ./deps.json);
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      inherit (source) owner repo rev;
      hash = deps.src.hash;
    };

    strictDeps = true;

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
