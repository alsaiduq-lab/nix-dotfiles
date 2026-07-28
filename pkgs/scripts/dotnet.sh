#!/usr/bin/env bash
set -euo pipefail

output="${1:?missing output path}"
package_attr="${PACKAGE_ATTR:?missing PACKAGE_ATTR}"
repo_root="${REPO_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
system="${REFRESH_SYSTEM:?missing REFRESH_SYSTEM}"

version="${VERSION:?missing VERSION}"
source_url="${SOURCE_URL:?missing SOURCE_URL}"
source_rev="${SOURCE_REV:?missing SOURCE_REV}"
dotnet_project_file="${DOTNET_PROJECT_FILE:?missing DOTNET_PROJECT_FILE}"
dotnet_test_project_file="${DOTNET_TEST_PROJECT_FILE:?missing DOTNET_TEST_PROJECT_FILE}"
dotnet_sdk="${DOTNET_SDK:?missing DOTNET_SDK}"
dotnet_flags="${DOTNET_FLAGS:?missing DOTNET_FLAGS}"
dotnet_platforms="${DOTNET_PLATFORMS:?missing DOTNET_PLATFORMS}"

src_log="$(mktemp)"
build_log="$(mktemp)"
deps_log="$(mktemp)"
nuget_deps="$(mktemp)"
empty_nuget_deps="$(mktemp)"

cleanup() {
  rm -f "$src_log" "$build_log" "$deps_log" "$nuget_deps" "$empty_nuget_deps"
}

trap cleanup EXIT
printf '[]\n' > "$empty_nuget_deps"

set +e
REPO_ROOT="$repo_root" \
SYSTEM="$system" \
SOURCE_URL="$source_url" \
SOURCE_REV="$source_rev" \
  nix build --no-link --impure --expr '
    let
      repoRoot = builtins.getEnv "REPO_ROOT";
      flake = builtins.getFlake repoRoot;
      lib = flake.inputs.nixpkgs.lib;
      pkgs = import flake.inputs.nixpkgs {
        system = builtins.getEnv "SYSTEM";
        config.allowUnfree = true;
      };
    in
      pkgs.fetchgit {
        url = builtins.getEnv "SOURCE_URL";
        rev = builtins.getEnv "SOURCE_REV";
        hash = lib.fakeHash;
      }
  ' > "$src_log" 2>&1
set -e

src_hash="$(sed -n 's/.*got:[[:space:]]*\(sha256-[A-Za-z0-9+/=]*\).*/\1/p' "$src_log" | tail -n1)"
if [ -z "$src_hash" ]; then
  cat "$src_log" >&2
  echo "$package_attr: failed to prefetch source" >&2
  exit 1
fi

if ! fetch_deps="$(
  REPO_ROOT="$repo_root" \
  PACKAGE_ATTR="$package_attr" \
  SYSTEM="$system" \
  VERSION="$version" \
  SRC_HASH="$src_hash" \
  SOURCE_URL="$source_url" \
  SOURCE_REV="$source_rev" \
  DOTNET_PROJECT_FILE="$dotnet_project_file" \
  DOTNET_TEST_PROJECT_FILE="$dotnet_test_project_file" \
  DOTNET_SDK="$dotnet_sdk" \
  DOTNET_FLAGS="$dotnet_flags" \
  DOTNET_PLATFORMS="$dotnet_platforms" \
  EMPTY_NUGET_DEPS="$empty_nuget_deps" \
    nix build --no-link --print-out-paths --impure --expr '
      let
        repoRoot = builtins.getEnv "REPO_ROOT";
        flake = builtins.getFlake repoRoot;
        pkgs = import flake.inputs.nixpkgs {
          system = builtins.getEnv "SYSTEM";
          config.allowUnfree = true;
        };

        packageAttr = builtins.getEnv "PACKAGE_ATTR";
        sourceUrl = builtins.getEnv "SOURCE_URL";
        sourceRev = builtins.getEnv "SOURCE_REV";
        srcHash = builtins.getEnv "SRC_HASH";
        dotnetSdkName = builtins.getEnv "DOTNET_SDK";
        emptyNugetDeps = /. + (builtins.getEnv "EMPTY_NUGET_DEPS");

        src = pkgs.fetchgit {
          url = sourceUrl;
          rev = sourceRev;
          hash = srcHash;
        };

        target = pkgs.buildDotnetModule {
          pname = packageAttr;
          version = builtins.getEnv "VERSION";
          inherit src;
          nugetDeps = emptyNugetDeps;
          projectFile = builtins.fromJSON (builtins.getEnv "DOTNET_PROJECT_FILE");
          testProjectFile = builtins.fromJSON (builtins.getEnv "DOTNET_TEST_PROJECT_FILE");
          dotnetFlags = builtins.fromJSON (builtins.getEnv "DOTNET_FLAGS");
          dotnet-sdk = pkgs.dotnetCorePackages.${dotnetSdkName};
          meta.platforms = builtins.fromJSON (builtins.getEnv "DOTNET_PLATFORMS");
        };
      in
        target.fetch-deps
    ' 2> "$build_log"
)"; then
  cat "$build_log" >&2
  exit 1
fi

if ! "$fetch_deps" "$nuget_deps" > "$deps_log" 2>&1; then
  cat "$deps_log" >&2
  exit 1
fi

jq -n \
  --arg srcHash "$src_hash" \
  --slurpfile nuget "$nuget_deps" \
  '
    {
      src: { hash: $srcHash },
      nuget: $nuget[0]
    }
  ' > "$output"
