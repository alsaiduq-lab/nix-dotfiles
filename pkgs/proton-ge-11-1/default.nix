{
  lib,
  stdenvNoCC,
  fetchurl,
  updateDeps,
}: let
  pname = "proton-ge-11-1";
  version = "GE-Proton11-1";
  deps = builtins.fromJSON (builtins.readFile ./deps.json);
  source = {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
  };
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchurl (source
      // {
        hash = deps.src.hash;
      });

    outputs = ["out" "steamcompattool"];

    installPhase = ''
      runHook preInstall

      echo "${pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

      mkdir -p $steamcompattool
      cp -a . $steamcompattool/

      runHook postInstall
    '';

    passthru = {
      depsFile = "pkgs/proton-ge-11-1/deps.json";
      "update-deps" = updateDeps.fetchurl (source
        // {
          name = pname;
        });
    };

    meta = {
      description = "GE-Proton11-1: GloriousEggroll's custom Proton build (Proton 11 rebase + winedmo/ffmpeg video playback rework)";
      homepage = "https://github.com/GloriousEggroll/proton-ge-custom";
      license = lib.licenses.bsd3;
      maintainers = ["Hibiki"];
      platforms = ["x86_64-linux"];
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  }
