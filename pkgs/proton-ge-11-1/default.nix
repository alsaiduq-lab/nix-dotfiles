{
  lib,
  stdenvNoCC,
  fetchurl,
}: let
  pname = "proton-ge-11-1";
  source = (import ../sources.nix).proton-ge-11-1;
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
      description = "GE-Proton11-1: GloriousEggroll's custom Proton build (Proton 11 rebase + winedmo/ffmpeg video playback rework)";
      homepage = "https://github.com/GloriousEggroll/proton-ge-custom";
      license = lib.licenses.bsd3;
      maintainers = ["Hibiki"];
      platforms = ["x86_64-linux"];
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  }
