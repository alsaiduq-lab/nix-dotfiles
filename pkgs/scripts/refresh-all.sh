#!/usr/bin/env bash
set -euo pipefail

manifest="${REFRESH_DEPS_MANIFEST:?missing REFRESH_DEPS_MANIFEST}"
libexec="${REFRESH_LIBEXEC:?missing REFRESH_LIBEXEC}"
system="${REFRESH_SYSTEM:?missing REFRESH_SYSTEM}"
filter="${1:-}"

if [ "$#" -gt 1 ]; then
  echo "usage: refresh-deps [package]" >&2
  exit 1
fi

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
tmp_files=()

cleanup() {
  if [ "${#tmp_files[@]}" -gt 0 ]; then
    rm -f "${tmp_files[@]}"
  fi
}

trap cleanup EXIT

prefetch_github() {
  local log hash
  log="$(mktemp)"

  REPO_ROOT="$repo_root" \
    SYSTEM="$system" \
    SOURCE="$1" \
    nix build --no-link --impure --expr '
      let
        source = builtins.fromJSON (builtins.getEnv "SOURCE");
        flake = builtins.getFlake (builtins.getEnv "REPO_ROOT");
        pkgs = import flake.inputs.nixpkgs {
          system = builtins.getEnv "SYSTEM";
        };
      in
        pkgs.fetchFromGitHub {
          inherit (source) owner repo rev;
          fetchSubmodules = source.fetchSubmodules or false;
          hash = pkgs.lib.fakeHash;
        }
    ' >"$log" 2>&1 || true

  hash="$(sed -n 's/.*got:[[:space:]]*\(sha256-[A-Za-z0-9+/=]*\).*/\1/p' "$log" | tail -n1)"
  rm -f "$log"

  if [ -z "$hash" ]; then
    echo "failed to derive hash for $(jq -r '"\(.owner)/\(.repo)"' <<<"$1")" >&2
    return 1
  fi

  echo "$hash"
}

entries="$(
  if [ -n "$filter" ]; then
    jq --arg attr "$filter" '[.[] | select(.attr == $attr)]' "$manifest"
  else
    jq '.' "$manifest"
  fi
)"

if [ "$(jq 'length' <<<"$entries")" -eq 0 ]; then
  if [ -n "$filter" ]; then
    echo "$filter: no source metadata" >&2
    exit 1
  fi

  echo "refresh-deps: no sources"
  exit 0
fi

while IFS= read -r entry; do
  package="$(jq -r '.attr' <<<"$entry")"
  deps="$repo_root/$(jq -r '.depsFile' <<<"$entry")"
  patch="$(mktemp)"
  merged="$(mktemp)"
  tmp_files+=("$patch" "$merged")

  version="$(jq -r '.version // empty' <<<"$entry")"

  echo "$package: checking"

  case "$(jq -r '.kind' <<<"$entry")" in
  crate)
    REPO_ROOT="$repo_root" \
      PACKAGE_ATTR="$package" \
      CRATE_PNAME="$(jq -r '.pname' <<<"$entry")" \
      VERSION="$version" \
      REFRESH_SYSTEM="$system" \
      "$libexec/rust-crate.sh" "$patch"
    ;;
  sourceBuild)
    if [ "$(jq 'has("dotnet")' <<<"$entry")" = "true" ]; then
      REPO_ROOT="$repo_root" \
        PACKAGE_ATTR="$package" \
        SOURCE_URL="$(jq -r '.url' <<<"$entry")" \
        SOURCE_REV="$(jq -r '.rev' <<<"$entry")" \
        VERSION="$version" \
        DOTNET_PROJECT_FILE="$(jq -c '.dotnet.projectFile' <<<"$entry")" \
        DOTNET_TEST_PROJECT_FILE="$(jq -c '.dotnet.testProjectFile' <<<"$entry")" \
        DOTNET_SDK="$(jq -r '.dotnet.sdk' <<<"$entry")" \
        DOTNET_FLAGS="$(jq -c '.dotnet.flags' <<<"$entry")" \
        DOTNET_PLATFORMS="$(jq -c '.dotnet.platforms' <<<"$entry")" \
        REFRESH_SYSTEM="$system" \
        "$libexec/dotnet.sh" "$patch"
    else
      REFRESH_URL="$(jq -r '"https://github.com/\(.owner)/\(.repo)/archive/\(.rev).tar.gz"' <<<"$entry")" \
      REFRESH_KEY="$(jq -r '.depsKey // "src"' <<<"$entry")" \
      REFRESH_UNPACK=true \
        "$libexec/hash-json.sh" "$patch"
    fi
    ;;
  url)
    REFRESH_URL="$(jq -r '.url' <<<"$entry")" \
    REFRESH_KEY=src \
    REFRESH_UNPACK=false \
      "$libexec/hash-json.sh" "$patch"
    ;;
  *)
    echo "$package: unsupported source kind" >&2
    exit 1
    ;;
  esac

  while IFS= read -r name; do
    echo "$package: checking $name"
    nested="$(jq -c --arg name "$name" '.[$name]' <<<"$entry")"
    nested_patch="$(mktemp)"
    tmp_files+=("$nested_patch")

    case "$(jq -r '.kind' <<<"$nested")" in
    sourceBuild)
      hash="$(prefetch_github "$nested")"
      jq -n --arg key "$name" --arg hash "$hash" '{ ($key): { hash: $hash } }' >"$nested_patch"
      ;;
    url)
      REFRESH_URL="$(jq -r '.url' <<<"$nested")" \
      REFRESH_KEY="$name" \
      REFRESH_UNPACK=false \
        "$libexec/hash-json.sh" "$nested_patch"
      ;;
    *)
      echo "$package: unsupported source kind for $name" >&2
      exit 1
      ;;
    esac

    jq -s '.[0] * .[1]' "$patch" "$nested_patch" >"$merged"
    mv "$merged" "$patch"
  done < <(jq -r 'to_entries[] | select(.value | type == "object" and has("kind")) | .key' <<<"$entry")

  mkdir -p "$(dirname "$deps")"
  if [ -f "$deps" ] && [ -s "$deps" ]; then
    jq -S -s '
      (.[0] | if type == "array" then { nuget: . } elif type == "object" then . else {} end) * .[1]
    ' "$deps" "$patch" >"$merged"
  else
    jq -S '.' "$patch" >"$merged"
  fi

  if [ -f "$deps" ] && cmp -s "$deps" "$merged"; then
    echo "$package: unchanged"
  else
    mv "$merged" "$deps"
    echo "$package: refreshed"
  fi
done < <(jq -c '.[]' <<<"$entries")
