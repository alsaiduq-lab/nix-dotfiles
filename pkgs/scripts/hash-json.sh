#!/usr/bin/env bash
set -euo pipefail

output="${1:?missing output path}"
url="${REFRESH_URL:?missing REFRESH_URL}"
key="${REFRESH_KEY:-src}"
unpack="${REFRESH_UNPACK:-false}"

prefetch_args=(--json)

if [ "$unpack" = "true" ]; then
  prefetch_args+=(--unpack)
fi

hash="$(nix store prefetch-file "${prefetch_args[@]}" "$url" | jq -r '.hash')"

jq -n \
  --arg key "$key" \
  --arg hash "$hash" \
  '{ ($key): { hash: $hash } }' > "$output"
