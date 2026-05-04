{
  pkgs,
  lib,
}: let
  readDeps = path: fallback: let
    text =
      if builtins.pathExists path
      then builtins.readFile path
      else "";
  in
    if text == ""
    then fallback
    else builtins.fromJSON text;

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
    version ? null,
    latestVersion ? null,
    ...
  }:
    mkUpdater {
      name = "${name}-update-deps";
      script = ./scripts/hash-json.sh;
      runtimeInputs =
        [
          pkgs.jq
          pkgs.nix
        ]
        ++ lib.optionals (latestVersion != null) [
          pkgs.curl
        ];
      env =
        {
          UPDATE_URL = url;
          UPDATE_KEY = key;
          UPDATE_UNPACK = lib.boolToString unpack;
        }
        // lib.optionalAttrs (version != null) {
          VERSION = version;
        }
        // lib.optionalAttrs (latestVersion != null) {
          LATEST_VERSION_URL = latestVersion.url;
          LATEST_VERSION_JQ = latestVersion.jq or ".";
        };
    };

  latestVersionSource = {
    githubRelease = {
      owner,
      repo,
      versionJq ? ".tag_name",
    }: {
      url = "https://api.github.com/repos/${owner}/${repo}/releases/latest";
      jq = versionJq;
    };

    crate = {pname}: {
      url = "https://crates.io/api/v1/crates/${pname}";
      jq = ".crate.max_version";
    };
  };

  renderAsset = asset: version:
    if builtins.isFunction asset
    then asset version
    else asset;

  versionJqFromTag = tag: let
    renderedTag = renderAsset tag "{version}";
    parts = builtins.match "^(.*)[{]version[}](.*)$" renderedTag;
    prefix =
      if parts == null
      then ""
      else builtins.elemAt parts 0;
    suffix =
      if parts == null
      then ""
      else builtins.elemAt parts 1;
  in
    ".tag_name"
    + lib.optionalString (prefix != "") " | ltrimstr(${builtins.toJSON prefix})"
    + lib.optionalString (suffix != "") " | rtrimstr(${builtins.toJSON suffix})";

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
    inherit readDeps;

    script = mkUpdater;

    dotnet = {
      name,
      version,
      srcHash,
      ...
    }:
      mkUpdater {
        name = "${name}-update-deps";
        script = ./scripts/dotnet.sh;
        runtimeInputs = [
          pkgs.gitMinimal
          pkgs.jq
          pkgs.nix
        ];
        env = {
          VERSION = version;
          SRC_HASH = srcHash;
          UPDATE_SYSTEM = pkgs.stdenv.hostPlatform.system;
        };
      };

    fetchurl = mkJsonHashUpdater;

    fetchGitHubReleaseAsset = {
      name,
      owner,
      repo,
      tag ? version: version,
      asset,
      key ? "src",
      versionJq ? versionJqFromTag tag,
      ...
    }:
      mkJsonHashUpdater {
        inherit name key;
        latestVersion = latestVersionSource.githubRelease {
          inherit owner repo versionJq;
        };
        url = "https://github.com/${owner}/${repo}/releases/download/${renderAsset tag "{version}"}/${renderAsset asset "{version}"}";
      };

    fetchFromGitHub = {
      name,
      owner,
      repo,
      rev,
      key ? "src",
      version ? null,
      ...
    }:
      mkJsonHashUpdater {
        inherit name key version;
        unpack = true;
        url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
      };

    fetchCrateRustPackage = {
      name,
      pname,
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
          LATEST_VERSION_URL = (latestVersionSource.crate {inherit pname;}).url;
          LATEST_VERSION_JQ = (latestVersionSource.crate {inherit pname;}).jq;
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
        pkgs.gnused
      ];
      env.UPDATE_DEPS_MANIFEST = "${manifest}";
    };
in {
  inherit updateDeps updateAll;
}
