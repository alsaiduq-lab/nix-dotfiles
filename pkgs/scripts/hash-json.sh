#!/usr/bin/env bash
set -euo pipefail

output="${1:?missing output path}"
url_template="${REFRESH_URL:?missing REFRESH_URL}"
key="${REFRESH_KEY:-src}"
unpack="${REFRESH_UNPACK:-false}"
version="${VERSION:-}"

if [ "$version" = "null" ]; then
  version=""
fi

if [ -n "$version" ]; then
  url="${url_template//\{version\}/$version}"
else
  url="$url_template"
fi

if [[ "$url" == *"{version}"* ]]; then
  echo "missing version for URL template: $url_template" >&2
  exit 1
fi

prefetch_args=(--json)

if [ "$unpack" = "true" ]; then
  prefetch_args+=(--unpack)
fi

hash="$(nix store prefetch-file "${prefetch_args[@]}" "$url" | jq -r '.hash')"

jq -n \
  --arg version "$version" \
  --arg key "$key" \
  --arg hash "$hash" \
  '{version: $version} | .[$key].hash = $hash' > "$output"
