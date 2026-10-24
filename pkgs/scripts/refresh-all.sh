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

entries="$(
  if [ -n "$filter" ]; then
    jq --arg attr "$filter" '[.[] | select(.attr == $attr)]' "$manifest"
  else
    jq '.' "$manifest"
  fi
)"

if [ "$(jq 'length' <<< "$entries")" -eq 0 ]; then
  if [ -n "$filter" ]; then
    echo "$filter: no source metadata" >&2
    exit 1
  fi

  echo "refresh-deps: no sources"
  exit 0
fi

while IFS= read -r entry; do
  package="$(jq -r '.attr' <<< "$entry")"
  deps="$repo_root/$(jq -r '.depsFile' <<< "$entry")"
  patch="$(mktemp)"
  merged="$(mktemp)"
  tmp_files+=("$patch" "$merged")

  version="$(jq -r '.version // empty' <<< "$entry")"

  echo "$package: checking"

  case "$(jq -r '.kind' <<< "$entry")" in
    crate)
      REPO_ROOT="$repo_root" \
      PACKAGE_ATTR="$package" \
      CRATE_PNAME="$(jq -r '.pname' <<< "$entry")" \
      VERSION="$version" \
      REFRESH_SYSTEM="$system" \
        "$libexec/rust-crate.sh" "$patch"
      ;;
    sourceBuild)
      if [ "$package" = "ryubing" ]; then
        REPO_ROOT="$repo_root" \
        PACKAGE_ATTR="$package" \
        SOURCE_URL="$(jq -r '.url' <<< "$entry")" \
        SOURCE_REV="$(jq -r '.rev' <<< "$entry")" \
        VERSION="$version" \
        DOTNET_PROJECT_FILE='"Ryujinx.sln"' \
        DOTNET_TEST_PROJECT_FILE='"src/Ryujinx.Tests/Ryujinx.Tests.csproj"' \
        DOTNET_SDK=sdk_10_0 \
        DOTNET_FLAGS='["/p:ExtraDefineConstants=DISABLE_UPDATER%2CFORCE_EXTERNAL_BASE_DIR"]' \
        DOTNET_PLATFORMS='["x86_64-linux","aarch64-linux","aarch64-darwin"]' \
        REFRESH_SYSTEM="$system" \
          "$libexec/dotnet.sh" "$patch"
      else
        key=src
        if [ "$package" = "rpcs3" ]; then
          key=discordRpc
        fi

        REFRESH_URL="$(jq -r '"https://github.com/\(.owner)/\(.repo)/archive/\(.rev).tar.gz"' <<< "$entry")" \
        REFRESH_KEY="$key" \
        REFRESH_UNPACK=true \
          "$libexec/hash-json.sh" "$patch"
      fi
      ;;
    url)
      REFRESH_URL="$(jq -r '.url' <<< "$entry")" \
      REFRESH_KEY=src \
      REFRESH_UNPACK=false \
        "$libexec/hash-json.sh" "$patch"
      ;;
    *)
      echo "$package: unsupported source kind" >&2
      exit 1
      ;;
  esac

  mkdir -p "$(dirname "$deps")"
  if [ -f "$deps" ] && [ -s "$deps" ]; then
    jq -S -s '
      (.[0] | if type == "array" then { nuget: . } elif type == "object" then . else {} end) * .[1]
    ' "$deps" "$patch" > "$merged"
  else
    jq -S '.' "$patch" > "$merged"
  fi

  if [ -f "$deps" ] && cmp -s "$deps" "$merged"; then
    echo "$package: unchanged"
  else
    mv "$merged" "$deps"
    echo "$package: refreshed"
  fi
done < <(jq -c '.[]' <<< "$entries")
