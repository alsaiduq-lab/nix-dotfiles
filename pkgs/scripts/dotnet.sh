#!/usr/bin/env bash
set -euo pipefail

output="${1:?missing output path}"
package_attr="${PACKAGE_ATTR:?missing PACKAGE_ATTR}"
repo_root="${REPO_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
system="${UPDATE_SYSTEM:?missing UPDATE_SYSTEM}"
build_log="$(mktemp)"
deps_log="$(mktemp)"

cleanup() {
  rm -f "$build_log" "$deps_log"
}

trap cleanup EXIT

if ! fetch_deps="$(
  REPO_ROOT="$repo_root" \
  PACKAGE_ATTR="$package_attr" \
  SYSTEM="$system" \
    nix build --no-link --print-out-paths --impure --expr '
      let
        repoRoot = builtins.getEnv "REPO_ROOT";
        flake = builtins.getFlake repoRoot;
        lib = flake.inputs.nixpkgs.lib;
        pkgs = import flake.inputs.nixpkgs {
          system = builtins.getEnv "SYSTEM";
          config.allowUnfree = true;
        };
        customPkgs = import (repoRoot + "/pkgs") {
          inherit pkgs lib;
        };
        target = lib.attrsets.getAttrFromPath (lib.strings.splitString "." (builtins.getEnv "PACKAGE_ATTR")) customPkgs;
      in
      target.fetch-deps
    ' 2> "$build_log"
)"; then
  cat "$build_log" >&2
  exit 1
fi

if ! "$fetch_deps" "$output" > "$deps_log" 2>&1; then
  cat "$deps_log" >&2
  exit 1
fi
