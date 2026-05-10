#!/usr/bin/env bash
set -euo pipefail

output="${1:?missing output path}"
url_template="${UPDATE_URL:?missing UPDATE_URL}"
key="${UPDATE_KEY:-src}"
unpack="${UPDATE_UNPACK:-false}"
version="${VERSION:-}"

if [ -n "${LATEST_VERSION_URL:-}" ]; then
  version="$(
    curl -fsSL \
      -H "Accept: application/json" \
      -H "User-Agent: nix-update-deps" \
      "$LATEST_VERSION_URL" \
      | jq -r "${LATEST_VERSION_JQ:-.}"
  )"
fi

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
  '
    {}
    | if $version != "" then .version = $version else . end
    | .[$key].hash = $hash
  ' > "$output"
