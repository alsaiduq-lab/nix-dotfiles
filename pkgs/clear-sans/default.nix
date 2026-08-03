{
  lib,
  stdenvNoCC,
  src,
}: let
  pname = "clear-sans";
  version = "1.0";
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    inherit src;

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
