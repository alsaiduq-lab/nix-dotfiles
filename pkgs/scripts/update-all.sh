#!/usr/bin/env bash
set -euo pipefail

manifest="${UPDATE_DEPS_MANIFEST:?missing UPDATE_DEPS_MANIFEST}"
filter="${1:-}"

if [ "$#" -gt 1 ]; then
  echo "usage: update-deps [package-attr]" >&2
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

write_if_changed() {
  package_attr="$1"
  src_file="$2"
  new_file="$3"

  mkdir -p "$(dirname "$src_file")"

  if [ -f "$src_file" ] && cmp -s "$src_file" "$new_file"; then
    echo "$package_attr: unchanged"
  else
    mv "$new_file" "$src_file"
    echo "$package_attr: updated"
  fi
}

entries="$(
  if [ -n "$filter" ]; then
    jq --arg attr "$filter" '[.[] | select(.attr == $attr)]' "$manifest"
  else
    jq '.' "$manifest"
  fi
)"

if [ "$(jq 'length' <<< "$entries")" -eq 0 ]; then
  if [ -n "$filter" ]; then
    echo "$filter: no update-deps metadata" >&2
    exit 1
  fi

  echo "update-deps: no packages"
  exit 0
fi

while IFS= read -r entry; do
  package_attr="$(jq -r '.attr' <<< "$entry")"
  deps_file="$repo_root/$(jq -r '.depsFile' <<< "$entry")"
  updater="$(jq -r '.updater' <<< "$entry")"

  patch_file="$(mktemp)"
  merged_file="$(mktemp)"
  tmp_files+=("$patch_file" "$merged_file")

  echo "$package_attr: checking"

  REPO_ROOT="$repo_root" \
  PACKAGE_ATTR="$package_attr" \
  DEPS_FILE="$deps_file" \
    "$updater" "$patch_file"

  if [ -f "$deps_file" ] && [ -s "$deps_file" ]; then
    jq -S -s '
      (
        .[0]
        | if type == "array" then
            { nuget: . }
          elif type == "object" then
            .
          else
            {}
          end
      ) * .[1]
    ' "$deps_file" "$patch_file" > "$merged_file"
  else
    jq -S '.' "$patch_file" > "$merged_file"
  fi

  write_if_changed "$package_attr" "$deps_file" "$merged_file"
done < <(jq -c '.[]' <<< "$entries")
