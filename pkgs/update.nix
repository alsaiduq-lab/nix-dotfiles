{
  pkgs,
  lib,
}: let
  mkUpdater = {
    name,
    script,
    runtimeInputs ? [],
    env ? {},
  }: let
    wrapperArgs =
      [
        "--prefix"
        "PATH"
        ":"
        (lib.makeBinPath runtimeInputs)
      ]
      ++ lib.concatLists (lib.mapAttrsToList (key: value: [
          "--set"
          key
          value
        ])
        env);
  in
    pkgs.stdenvNoCC.mkDerivation {
      pname = name;
      version = "1";
      src = script;

      dontUnpack = true;
      nativeBuildInputs = [pkgs.makeWrapper];

      installPhase = ''
        runHook preInstall

        install -Dm755 $src $out/bin/${name}
        patchShebangs $out/bin/${name}
        wrapProgram $out/bin/${name} ${lib.concatMapStringsSep " " lib.escapeShellArg wrapperArgs}

        runHook postInstall
      '';

      meta.mainProgram = name;
    };

  mkJsonHashUpdater = {
    name,
    url,
    key ? "src",
    unpack ? false,
    ...
  }:
    mkUpdater {
      name = "${name}-update-deps";
      script = ./scripts/hash-json.sh;
      runtimeInputs = [
        pkgs.jq
        pkgs.nix
      ];
      env = {
        UPDATE_URL = url;
        UPDATE_KEY = key;
        UPDATE_UNPACK = lib.boolToString unpack;
      };
    };

  collectUpdaters = path: value:
    if lib.isDerivation value
    then
      lib.optional (builtins.hasAttr "update-deps" value && builtins.hasAttr "depsFile" value) {
        attr = lib.concatStringsSep "." path;
        depsFile = value.depsFile;
        updater = lib.getExe value."update-deps";
      }
    else if builtins.isAttrs value
    then lib.concatLists (lib.mapAttrsToList (name: child: collectUpdaters (path ++ [name]) child) value)
    else [];

  updateDeps = {
    script = mkUpdater;

    dotnet = mkUpdater {
      name = "dotnet-update-deps";
      script = ./scripts/dotnet.sh;
      runtimeInputs = [
        pkgs.gitMinimal
        pkgs.nix
      ];
      env.UPDATE_SYSTEM = pkgs.stdenv.hostPlatform.system;
    };

    fetchurl = mkJsonHashUpdater;

    fetchFromGitHub = {
      name,
      owner,
      repo,
      rev,
      key ? "src",
      ...
    }:
      mkJsonHashUpdater {
        inherit name key;
        unpack = true;
        url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
      };

    fetchCrateRustPackage = {
      name,
      pname,
      version,
    }:
      mkUpdater {
        name = "${name}-update-deps";
        script = ./scripts/rust-crate.sh;
        runtimeInputs = [
          pkgs.gitMinimal
          pkgs.gnused
          pkgs.jq
          pkgs.nix
        ];
        env = {
          CRATE_PNAME = pname;
          CRATE_VERSION = version;
          UPDATE_SYSTEM = pkgs.stdenv.hostPlatform.system;
        };
      };
  };

  updateAll = packageSet: let
    manifest = pkgs.writeText "update-deps-manifest.json" (builtins.toJSON (collectUpdaters [] packageSet));
  in
    mkUpdater {
      name = "update-deps";
      script = ./scripts/update-all.sh;
      runtimeInputs = [
        pkgs.jq
        pkgs.gitMinimal
      ];
      env.UPDATE_DEPS_MANIFEST = "${manifest}";
    };
in {
  inherit updateDeps updateAll;
}
