#!/usr/bin/env bash
set -euo pipefail

output="${1:?missing output path}"
url="${UPDATE_URL:?missing UPDATE_URL}"
key="${UPDATE_KEY:-src}"
unpack="${UPDATE_UNPACK:-false}"

prefetch_args=(--json)

if [ "$unpack" = "true" ]; then
  prefetch_args+=(--unpack)
fi

hash="$(nix store prefetch-file "${prefetch_args[@]}" "$url" | jq -r '.hash')"

jq -n \
  --arg key "$key" \
  --arg hash "$hash" \
  '{ ($key): { hash: $hash } }' > "$output"
