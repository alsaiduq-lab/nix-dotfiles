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

  versionedAsset = asset: version:
    if builtins.isFunction asset
    then asset "{version}"
    else if version == null
    then asset
    else builtins.replaceStrings [version] ["{version}"] asset;

  hasVersionToken = asset:
    builtins.match ".*[{]version[}].*" asset != null;

  updateSources = import ./update-sources.nix {inherit updateDeps;};

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

  isUpdateSource = value:
    builtins.isAttrs value && builtins.hasAttr "depsFile" value && builtins.hasAttr "updater" value;

  collectUpdateSources = path: value:
    if isUpdateSource value
    then let
      attr = lib.concatStringsSep "." path;
    in
      if lib.isDerivation value.updater
      then [
        {
          inherit attr;
          depsFile = value.depsFile;
          updater = lib.getExe value.updater;
        }
      ]
      else throw "${attr}: updater is ${builtins.typeOf value.updater}, expected a derivation"
    else if builtins.isAttrs value
    then lib.concatLists (lib.mapAttrsToList (name: child: collectUpdateSources (path ++ [name]) child) value)
    else [];

  updateDeps = {
    inherit readDeps;

    script = mkUpdater;

    dotnet = {
      name,
      version ? null,
      srcHash ? null,
      url ? null,
      rev ? null,
      fetcher ? "fetchgit",
      unpack ? false,
      latestVersion ? null,
      projectFile ? null,
      testProjectFile ? null,
      dotnetSdk ? null,
      dotnetFlags ? [],
      platforms ? null,
      ...
    }:
      mkUpdater {
        name = "${name}-update-deps";
        script = ./scripts/dotnet.sh;
        runtimeInputs =
          [
            pkgs.gitMinimal
            pkgs.gnused
            pkgs.jq
            pkgs.nix
          ]
          ++ lib.optionals (latestVersion != null) [
            pkgs.curl
          ];
        env =
          {
            UPDATE_SYSTEM = pkgs.stdenv.hostPlatform.system;
            SOURCE_FETCHER = fetcher;
            UPDATE_UNPACK = lib.boolToString unpack;
          }
          // lib.optionalAttrs (version != null) {
            VERSION = version;
          }
          // lib.optionalAttrs (srcHash != null) {
            SRC_HASH = srcHash;
          }
          // lib.optionalAttrs (url != null) {
            SOURCE_URL = url;
          }
          // lib.optionalAttrs (rev != null) {
            SOURCE_REV = versionedAsset rev version;
          }
          // lib.optionalAttrs (latestVersion != null) {
            LATEST_VERSION_URL = latestVersion.url;
            LATEST_VERSION_JQ = latestVersion.jq or ".";
          }
          // lib.optionalAttrs (projectFile != null) {
            DOTNET_PROJECT_FILE = builtins.toJSON projectFile;
          }
          // lib.optionalAttrs (testProjectFile != null) {
            DOTNET_TEST_PROJECT_FILE = builtins.toJSON testProjectFile;
          }
          // lib.optionalAttrs (dotnetSdk != null) {
            DOTNET_SDK = dotnetSdk;
          }
          // lib.optionalAttrs (dotnetFlags != []) {
            DOTNET_FLAGS = builtins.toJSON dotnetFlags;
          }
          // lib.optionalAttrs (platforms != null) {
            DOTNET_PLATFORMS = builtins.toJSON platforms;
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
      latestVersion ? null,
      versionJq ? null,
      ...
    }: let
      versionedRev = versionedAsset rev version;
      shouldBumpVersion = hasVersionToken versionedRev;

      resolvedLatestVersion =
        if latestVersion != null
        then latestVersion
        else if shouldBumpVersion
        then
          latestVersionSource.githubRelease {
            inherit owner repo;
            versionJq =
              if versionJq != null
              then versionJq
              else versionJqFromTag versionedRev;
          }
        else null;
    in
      mkJsonHashUpdater {
        inherit name key version;
        latestVersion = resolvedLatestVersion;
        unpack = true;
        url = "https://github.com/${owner}/${repo}/archive/${versionedRev}.tar.gz";
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
          pkgs.curl
        ];
        env = {
          CRATE_PNAME = pname;
          LATEST_VERSION_URL = (latestVersionSource.crate {inherit pname;}).url;
          LATEST_VERSION_JQ = (latestVersionSource.crate {inherit pname;}).jq;
          UPDATE_SYSTEM = pkgs.stdenv.hostPlatform.system;
        };
      };
  };

  updateAll = let
    manifest = pkgs.writeText "update-deps-manifest.json" (builtins.toJSON (collectUpdateSources [] updateSources));
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
