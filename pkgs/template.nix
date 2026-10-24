{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  # you can also choose to import as needed from nixpkgs for example:
  # rsync,
  # makeWrapper,        # creates a .wrapped version; mainly used for bundling deps (no FHS on nix)
  # installShellFiles,
  # copyDesktopItems,  # installs desktop files
  # python3,
  # writeText,
}: let
  pname = "example";
  version = "1.0.0";

  # Note: deps.json sits next to this file and keeps prefetched hashes ready for every
  # fetched source in pkgs/*.
  deps = builtins.fromJSON (builtins.readFile ./deps.json);
  # example to vendor a config (you need writeText imported)
  # lib.generators also has toINI, toYAML, toGitINI, toKeyValue, etc.
  # pkgConfig = writeText "${pname}.conf" (lib.generators.toINI {} {
  #   main = {
  #     data_dir = "/var/lib/${pname}";
  #     log_level = "info";
  #   };
  # });
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "owner";
      repo = pname;
      rev = "v${version}";
      hash = deps.src.hash; # hash lives in deps.json, see note above
    };

    strictDeps = true;

    # nativeBuildInputs = [
    #   rsync
    #   makeWrapper
    #   installShellFiles
    #   copyDesktopItems
    # ];

    # Note: there can be a case where the vendor assumes you are on FHS and hardcodes shebangs.
    # In this case, fix shebangs before install. patchShebangs rewrites
    # `#!/bin/sh`, etc. to store paths, resolving interpreters from nativeBuildInputs / stdenv.
    # postPatch = ''
    #   patchShebangs scripts/ tools/
    #
    #   # Or:
    #   substituteInPlace src/launcher.sh \
    #     --replace-fail "/usr/bin/python3" "${lib.getExe python3}"
    # '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/${pname}
      cp -a . $out/share/${pname}/

      # rsync -a --exclude='.git*' --exclude='tests/' --exclude='*.md' \
      #   . $out/share/${pname}/

      # install -Dm644 ${"$"}{generatedConf} $out/share/${pname}/config.ini

      # installManPage docs/${pname}.1
      # installShellCompletion --fish completions/${pname}.fish

      runHook postInstall
    '';

    # postFixup = ''
    #   makeWrapper $out/share/${pname}/run.sh $out/bin/${pname} \
    #     --prefix PATH : ${"$"}{lib.makeBinPath [/* runtime tools */]} \
    #     --set-default DATA_DIR "\''${XDG_DATA_HOME:-\$HOME/.local/share}/${pname}"
    # '';

    meta = {
      description = "Example package";
      homepage = "https://github.com/owner/${pname}";
      license = lib.licenses.mit;
      maintainers = ["Name"];
      platforms = lib.platforms.all;
      # mainProgram = pname;  # enables lib.getExe on this package
    };
  }
