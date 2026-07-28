{
  lib,
  stdenvNoCC,
  fetchurl,
}: let
  pname = "proton-ge-11";
  source = (import ../sources.nix).proton-ge-11;
  inherit (source) version;
  deps = builtins.fromJSON (builtins.readFile ./deps.json);
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchurl {
      inherit (source) url;
      hash = deps.src.hash;
    };

    outputs = ["out" "steamcompattool"];
    strictDeps = true;

    installPhase = ''
      runHook preInstall

      echo "${pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

      mkdir -p $steamcompattool
      cp -a . $steamcompattool/

      runHook postInstall
    '';

    meta = {
      description = "GE-Proton: GloriousEggroll's custom Proton build (ffmpeg video playback rework)";
      homepage = "https://github.com/GloriousEggroll/proton-ge-custom";
      license = lib.licenses.bsd3;
      maintainers = ["Hibiki"];
      platforms = ["x86_64-linux"];
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  }
