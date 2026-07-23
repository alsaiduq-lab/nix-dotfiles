#!/usr/bin/env bash
set -euo pipefail

manifest="${REFRESH_DEPS_MANIFEST:?missing REFRESH_DEPS_MANIFEST}"
libexec="${REFRESH_LIBEXEC:?missing REFRESH_LIBEXEC}"
system="${REFRESH_SYSTEM:?missing REFRESH_SYSTEM}"
sources="${REFRESH_SOURCES:?missing REFRESH_SOURCES}"
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

update_source() {
  local package="$1"
  local old="$2"
  local new="$3"
  local source_file="$4"
  local new_file="$5"

  awk -v package="$package" -v old="$old" -v new="$new" '
    function replace(line, pos) {
      while ((pos = index(line, old)) != 0) {
        line = substr(line, 1, pos - 1) new substr(line, pos + length(old))
        changes++
      }
      return line
    }
    index($0, "  " package " = ") == 1 { entry = 1 }
    entry && /^  [^ ]/ && index($0, "  " package " = ") != 1 { entry = 0 }
    entry {
      print replace($0)
      next
    }
    { print }
    END { if (changes < 2) exit 1 }
  ' "$source_file" > "$new_file"
}

entries="$(
  if [ -n "$filter" ]; then
    jq --arg attr "$filter" '[.[] | select(.attr == $attr)]' "$manifest"
  else
    locked="$(jq '[.[] | select(.locked == true)] | length' "$manifest")"
    if [ "$locked" -gt 0 ]; then
      echo "refresh-deps: skipping $locked locked sources" >&2
    fi
    jq '[.[] | select(.locked != true)]' "$manifest"
  fi
)"

if [ "$(jq 'length' <<< "$entries")" -eq 0 ]; then
  if [ -n "$filter" ]; then
    echo "$filter: no source metadata" >&2
    exit 1
  fi

  echo "refresh-deps: no unlocked sources"
  exit 0
fi

while IFS= read -r entry; do
  package="$(jq -r '.attr' <<< "$entry")"
  deps="$repo_root/$(jq -r '.depsFile' <<< "$entry")"
  patch="$(mktemp)"
  merged="$(mktemp)"
  tmp_files+=("$patch" "$merged")

  version=""
  declared="$(jq -r '.version // empty' <<< "$entry")"
  version="$declared"
  latest_url="$(jq -r '.latest.url // empty' <<< "$entry")"
  if [ -n "$latest_url" ]; then
    version="$(
      curl -fsSL \
        -H "Accept: application/json" \
        -H "User-Agent: nix-refresh-deps" \
        "$latest_url" \
        | jq -r "$(jq -r '.latest.query' <<< "$entry")"
    )"
  fi

  url="$(jq -r '.url // empty' <<< "$entry")"
  if [ -n "$url" ] && [ -n "$declared" ] && [ "$version" != "$declared" ]; then
    url="${url//$declared/$version}"
  fi

  echo "$package: checking"

  case "$(jq -r '.kind' <<< "$entry")" in
    dotnet)
      REPO_ROOT="$repo_root" \
      PACKAGE_ATTR="$package" \
      SOURCE_URL="$(jq -r '.url' <<< "$entry")" \
      SOURCE_REV="$(jq -r '.rev // empty' <<< "$entry")" \
      SOURCE_FETCHER="$(jq -r '.fetcher // "fetchgit"' <<< "$entry")" \
      REFRESH_UNPACK="$(jq -r '.unpack // false' <<< "$entry")" \
      VERSION="$version" \
      SRC_HASH="$(jq -r '.srcHash // empty' <<< "$entry")" \
      DOTNET_PROJECT_FILE="$(jq -c '.projectFile // null' <<< "$entry")" \
      DOTNET_TEST_PROJECT_FILE="$(jq -c '.testProjectFile // null' <<< "$entry")" \
      DOTNET_SDK="$(jq -r '.dotnetSdk // empty' <<< "$entry")" \
      DOTNET_FLAGS="$(jq -c '.dotnetFlags // []' <<< "$entry")" \
      DOTNET_PLATFORMS="$(jq -c '.platforms // null' <<< "$entry")" \
      REFRESH_SYSTEM="$system" \
        "$libexec/dotnet.sh" "$patch"
      ;;
    github)
      REFRESH_URL="${url:-$(jq -r '"https://github.com/\(.owner)/\(.repo)/archive/\(.rev).tar.gz"' <<< "$entry")}" \
      REFRESH_KEY="$(jq -r '.key // "src"' <<< "$entry")" \
      REFRESH_UNPACK=true \
      VERSION="$version" \
        "$libexec/hash-json.sh" "$patch"
      ;;
    githubAsset)
      REFRESH_URL="${url:-$(jq -r '"https://github.com/\(.owner)/\(.repo)/releases/download/\(.tag // "{version}")/\(.asset)"' <<< "$entry")}" \
      REFRESH_KEY="$(jq -r '.key // "src"' <<< "$entry")" \
      REFRESH_UNPACK="$(jq -r '.unpack // false' <<< "$entry")" \
      VERSION="$version" \
        "$libexec/hash-json.sh" "$patch"
      ;;
    rustCrate)
      pname="$(jq -r '.pname' <<< "$entry")"
      REPO_ROOT="$repo_root" \
      PACKAGE_ATTR="$package" \
      CRATE_PNAME="$pname" \
      VERSION="$version" \
      REFRESH_SYSTEM="$system" \
        "$libexec/rust-crate.sh" "$patch"
      ;;
    url)
      REFRESH_URL="$url" \
      REFRESH_KEY="$(jq -r '.key // "src"' <<< "$entry")" \
      REFRESH_UNPACK="$(jq -r '.unpack // false' <<< "$entry")" \
      VERSION="$version" \
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
      ((.[0] | if type == "array" then { nuget: . } elif type == "object" then . else {} end) * .[1])
      | del(.version)
    ' "$deps" "$patch" > "$merged"
  else
    jq -S '.' "$patch" > "$merged"
  fi

  source_file="$repo_root/$sources"
  source_tmp=""
  if [ -n "$latest_url" ] && [ "$version" != "$declared" ]; then
    source_tmp="$(mktemp)"
    tmp_files+=("$source_tmp")
    update_source "$package" "$declared" "$version" "$source_file" "$source_tmp"
  fi

  if [ -f "$deps" ] && cmp -s "$deps" "$merged"; then
    echo "$package: unchanged"
  else
    mv "$merged" "$deps"
    echo "$package: refreshed"
  fi

  if [ -n "$source_tmp" ]; then
    mv "$source_tmp" "$source_file"
    echo "$package: version $declared -> $version"
  fi
done < <(jq -c '.[]' <<< "$entries")
