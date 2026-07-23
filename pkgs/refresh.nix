{
  pkgs,
  lib,
  packages,
}: let
  sources = import ./sources.nix;
  kinds = [
    "dotnet"
    "github"
    "githubAsset"
    "rustCrate"
    "url"
  ];

  entries = lib.mapAttrsToList (name: source:
    if !builtins.hasAttr name packages
    then throw "source '${name}' does not refer to a discovered package"
    else if !builtins.isAttrs source
    then throw "source '${name}' must be an attribute set"
    else if !builtins.hasAttr "kind" source || !builtins.elem source.kind kinds
    then throw "source '${name}' has an unsupported kind"
    else if
      (source.kind == "dotnet" && !(builtins.hasAttr "url" source && builtins.hasAttr "rev" source))
      || (source.kind == "github" && !(builtins.hasAttr "url" source || (builtins.hasAttr "owner" source && builtins.hasAttr "repo" source && builtins.hasAttr "rev" source)))
      || (source.kind == "githubAsset" && !(builtins.hasAttr "url" source || (builtins.hasAttr "owner" source && builtins.hasAttr "repo" source && builtins.hasAttr "asset" source)))
      || (source.kind == "rustCrate" && !builtins.hasAttr "pname" source)
      || (source.kind == "url" && !builtins.hasAttr "url" source)
    then throw "source '${name}' is missing fields required by kind '${source.kind}'"
    else if builtins.hasAttr "latest" source && (!builtins.isAttrs source.latest || !(builtins.hasAttr "url" source.latest && builtins.hasAttr "query" source.latest))
    then throw "source '${name}'.latest requires url and query"
    else
      source
      // {
        attr = name;
        depsFile = "pkgs/${name}/deps.json";
      })
  sources;

  manifest = pkgs.writeText "refresh-deps.json" (builtins.toJSON entries);
in
  pkgs.stdenvNoCC.mkDerivation {
    pname = "refresh-deps";
    version = "1";

    strictDeps = true;
    dontUnpack = true;

    nativeBuildInputs = [pkgs.makeWrapper];

    installPhase = ''
      runHook preInstall

      install -Dm755 ${./scripts/refresh-all.sh} $out/bin/refresh-deps
      install -Dm755 ${./scripts/dotnet.sh} $out/libexec/dotnet.sh
      install -Dm755 ${./scripts/hash-json.sh} $out/libexec/hash-json.sh
      install -Dm755 ${./scripts/rust-crate.sh} $out/libexec/rust-crate.sh

      patchShebangs $out/bin $out/libexec
      wrapProgram $out/bin/refresh-deps \
        --prefix PATH : ${lib.makeBinPath [pkgs.curl pkgs.gitMinimal pkgs.gnused pkgs.jq pkgs.nix]} \
        --set REFRESH_DEPS_MANIFEST ${manifest} \
        --set REFRESH_LIBEXEC $out/libexec \
        --set REFRESH_SOURCES pkgs/sources.nix \
        --set REFRESH_SYSTEM ${pkgs.stdenv.hostPlatform.system}

      runHook postInstall
    '';

    meta.mainProgram = "refresh-deps";
  }
