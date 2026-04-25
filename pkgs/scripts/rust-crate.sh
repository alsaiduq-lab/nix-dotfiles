#!/usr/bin/env bash
set -euo pipefail

output="${1:?missing output path}"
package_attr="${PACKAGE_ATTR:?missing PACKAGE_ATTR}"
repo_root="${REPO_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
system="${UPDATE_SYSTEM:?missing UPDATE_SYSTEM}"
crate_pname="${CRATE_PNAME:?missing CRATE_PNAME}"
crate_version="${CRATE_VERSION:?missing CRATE_VERSION}"

src_hash="$(
  nix store prefetch-file --json --unpack "https://static.crates.io/crates/$crate_pname/$crate_pname-$crate_version.crate" \
    | jq -r '.hash'
)"

build_log="$(mktemp)"

cleanup() {
  rm -f "$build_log"
}

trap cleanup EXIT

set +e
REPO_ROOT="$repo_root" \
PACKAGE_ATTR="$package_attr" \
SYSTEM="$system" \
SRC_HASH="$src_hash" \
CRATE_PNAME="$crate_pname" \
CRATE_VERSION="$crate_version" \
  nix build --no-link --impure --expr '
      let
        repoRoot = builtins.getEnv "REPO_ROOT";
        packageAttr = builtins.getEnv "PACKAGE_ATTR";
        srcHash = builtins.getEnv "SRC_HASH";
        flake = builtins.getFlake repoRoot;
        lib = flake.inputs.nixpkgs.lib;
        pkgs = import flake.inputs.nixpkgs {
          system = builtins.getEnv "SYSTEM";
          config.allowUnfree = true;
        };
        customPkgs = import (repoRoot + "/pkgs") {
          inherit pkgs lib;
        };
        src = pkgs.fetchCrate {
          pname = builtins.getEnv "CRATE_PNAME";
          version = builtins.getEnv "CRATE_VERSION";
          hash = srcHash;
        };
        target = lib.attrsets.getAttrFromPath (lib.strings.splitString "." packageAttr) customPkgs;
        cargoDeps =
          if target ? cargoDeps
          then target.cargoDeps
          else throw "${packageAttr}: package does not expose cargoDeps";
        vendorSource =
          if cargoDeps ? vendorStaging
          then cargoDeps.vendorStaging
          else cargoDeps;
      in
      vendorSource.overrideAttrs (_: {
        inherit src;
        outputHash = lib.fakeHash;
      })
    ' > "$build_log" 2>&1
build_status="$?"
set -e

cargo_hash="$(sed -n 's/.*got:[[:space:]]*\(sha256-[A-Za-z0-9+/=]*\).*/\1/p' "$build_log" | tail -n1)"

if [ -z "$cargo_hash" ]; then
  cat "$build_log" >&2

  if [ "$build_status" -eq 0 ]; then
    echo "cargo hash for $package_attr was already accepted; keeping existing hash" >&2
  fi

  echo "failed to derive cargo hash for $package_attr" >&2
  exit 1
fi

jq -n \
  --arg srcHash "$src_hash" \
  --arg cargoHash "$cargo_hash" \
  '{ src: { hash: $srcHash }, cargo: { hash: $cargoHash } }' > "$output"
