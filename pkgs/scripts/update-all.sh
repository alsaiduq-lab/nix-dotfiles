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

  if cmp -s "$src_file" "$new_file"; then
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
    echo "$filter: no update-deps metadata"
    exit 1
  fi

  echo "update-deps: no packages"
  exit 0
fi

while IFS= read -r entry; do
  package_attr="$(jq -r '.attr' <<< "$entry")"
  deps_file="$repo_root/$(jq -r '.depsFile' <<< "$entry")"
  updater="$(jq -r '.updater' <<< "$entry")"
  tmp_file="$(mktemp)"
  tmp_files+=("$tmp_file")

  echo "$package_attr: checking"
  REPO_ROOT="$repo_root" PACKAGE_ATTR="$package_attr" "$updater" "$tmp_file"
  write_if_changed "$package_attr" "$deps_file" "$tmp_file"
done < <(jq -c '.[]' <<< "$entries")
