#!/usr/bin/env bash
set -euo pipefail

output="${1:?missing output path}"
package_attr="${PACKAGE_ATTR:?missing PACKAGE_ATTR}"
repo_root="${REPO_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
system="${UPDATE_SYSTEM:?missing UPDATE_SYSTEM}"

version="${VERSION:-}"
src_hash="${SRC_HASH:-}"
source_url="${SOURCE_URL:-}"
source_rev="${SOURCE_REV:-}"
source_fetcher="${SOURCE_FETCHER:-fetchgit}"
unpack="${UPDATE_UNPACK:-false}"
dotnet_project_file="${DOTNET_PROJECT_FILE:-null}"
dotnet_test_project_file="${DOTNET_TEST_PROJECT_FILE:-null}"
dotnet_sdk="${DOTNET_SDK:-}"
dotnet_flags="${DOTNET_FLAGS:-[]}"
dotnet_platforms="${DOTNET_PLATFORMS:-null}"

build_log="$(mktemp)"
deps_log="$(mktemp)"
nuget_deps="$(mktemp)"
empty_nuget_deps="$(mktemp)"

cleanup() {
  rm -f "$build_log" "$deps_log" "$nuget_deps" "$empty_nuget_deps"
}

trap cleanup EXIT
printf '[]\n' > "$empty_nuget_deps"

if [ -n "${LATEST_VERSION_URL:-}" ]; then
  version="$(
    curl -fsSL \
      -H "Accept: application/json" \
      -H "User-Agent: nix-update-deps" \
      "$LATEST_VERSION_URL" \
      | jq -r "${LATEST_VERSION_JQ:-.}"
  )"
fi

if [ -z "$version" ] || [ "$version" = "null" ]; then
  echo "$package_attr: missing version" >&2
  exit 1
fi

if [ -n "$source_rev" ]; then
  source_rev="${source_rev//\{version\}/$version}"
fi

if [[ "$source_rev" == *"{version}"* ]]; then
  echo "$package_attr: unresolved source rev template: $SOURCE_REV" >&2
  exit 1
fi

if [ -z "$source_url" ]; then
  echo "$package_attr: SOURCE_URL is required" >&2
  exit 1
fi

prefetch_fetchgit() {
  local log
  log="$(mktemp)"

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
    ' > "$log" 2>&1
  local status="$?"
  set -e

  src_hash="$(sed -n 's/.*got:[[:space:]]*\(sha256-[A-Za-z0-9+/=]*\).*/\1/p' "$log" | tail -n1)"
  rm -f "$log"

  if [ -z "$src_hash" ]; then
    echo "$package_attr: failed to prefetch fetchgit source" >&2
    exit "$status"
  fi
}

prefetch_file() {
  local url="$source_url"
  url="${url//\{version\}/$version}"

  if [[ "$url" == *"{version}"* ]]; then
    echo "$package_attr: unresolved source URL template: $source_url" >&2
    exit 1
  fi

  local args=(--json)

  if [ "$unpack" = "true" ] || [ "$source_fetcher" = "fetchzip" ]; then
    args+=(--unpack)
  fi

  src_hash="$(nix store prefetch-file "${args[@]}" "$url" | jq -r '.hash')"
  source_url="$url"
}

if [ -n "$source_url" ]; then
  case "$source_fetcher" in
    fetchgit)
      if [ -z "$source_rev" ]; then
        echo "$package_attr: SOURCE_REV is required for fetchgit" >&2
        exit 1
      fi
      prefetch_fetchgit
      ;;
    fetchurl | fetchzip)
      prefetch_file
      ;;
    *)
      echo "$package_attr: unsupported SOURCE_FETCHER: $source_fetcher" >&2
      exit 1
      ;;
  esac
fi

if [ -z "$src_hash" ]; then
  echo "$package_attr: missing src hash" >&2
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
  SOURCE_FETCHER="$source_fetcher" \
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
        lib = flake.inputs.nixpkgs.lib;
        pkgs = import flake.inputs.nixpkgs {
          system = builtins.getEnv "SYSTEM";
          config.allowUnfree = true;
        };

        packageAttr = builtins.getEnv "PACKAGE_ATTR";
        sourceUrl = builtins.getEnv "SOURCE_URL";
        sourceRev = builtins.getEnv "SOURCE_REV";
        sourceFetcher = builtins.getEnv "SOURCE_FETCHER";
        srcHash = builtins.getEnv "SRC_HASH";
        dotnetSdkName = builtins.getEnv "DOTNET_SDK";
        emptyNugetDeps = /. + (builtins.getEnv "EMPTY_NUGET_DEPS");

        fromJsonEnv = name: fallback: let
          value = builtins.getEnv name;
        in
          if value == ""
          then fallback
          else builtins.fromJSON value;

        src =
          if sourceFetcher == "fetchgit" then
            pkgs.fetchgit {
              url = sourceUrl;
              rev = sourceRev;
              hash = srcHash;
            }
          else if sourceFetcher == "fetchurl" then
            pkgs.fetchurl {
              url = sourceUrl;
              hash = srcHash;
            }
          else if sourceFetcher == "fetchzip" then
            pkgs.fetchzip {
              url = sourceUrl;
              hash = srcHash;
            }
          else
            throw "${packageAttr}: unsupported SOURCE_FETCHER: ${sourceFetcher}";

        dotnetSdk =
          if dotnetSdkName == ""
          then pkgs.dotnet-sdk
          else pkgs.dotnetCorePackages.${dotnetSdkName};

        platforms = fromJsonEnv "DOTNET_PLATFORMS" null;

        target = pkgs.buildDotnetModule ({
          pname = packageAttr;
          version = builtins.getEnv "VERSION";
          inherit src;
          nugetDeps = emptyNugetDeps;
          projectFile = fromJsonEnv "DOTNET_PROJECT_FILE" null;
          testProjectFile = fromJsonEnv "DOTNET_TEST_PROJECT_FILE" null;
          dotnetFlags = fromJsonEnv "DOTNET_FLAGS" [];
          dotnet-sdk = dotnetSdk;
        } // lib.optionalAttrs (platforms != null) {
          meta.platforms = platforms;
        });
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
  --arg version "$version" \
  --arg srcHash "$src_hash" \
  --slurpfile nuget "$nuget_deps" \
  '
    {
      version: $version,
      src: { hash: $srcHash },
      nuget: $nuget[0]
    }
  ' > "$output"
