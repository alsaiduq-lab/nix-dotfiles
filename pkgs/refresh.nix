{
  pkgs,
  lib,
  packages,
}: let
  sources = import ./sources.nix;
  kinds = [
    "crate"
    "sourceBuild"
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
      (source.kind == "crate" && !(builtins.hasAttr "version" source && builtins.hasAttr "pname" source))
      || (source.kind == "sourceBuild" && !(builtins.hasAttr "rev" source && (builtins.hasAttr "url" source || (builtins.hasAttr "owner" source && builtins.hasAttr "repo" source))))
      || (source.kind == "url" && !(builtins.hasAttr "version" source && builtins.hasAttr "url" source))
    then throw "source '${name}' is missing fields required by kind '${source.kind}'"
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
        --prefix PATH : ${lib.makeBinPath [pkgs.gitMinimal pkgs.gnused pkgs.jq pkgs.nix]} \
        --set REFRESH_DEPS_MANIFEST ${manifest} \
        --set REFRESH_LIBEXEC $out/libexec \
        --set REFRESH_SYSTEM ${pkgs.stdenv.hostPlatform.system}

      runHook postInstall
    '';

    meta.mainProgram = "refresh-deps";
  }
