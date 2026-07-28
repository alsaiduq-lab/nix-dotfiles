#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $(basename "$0") [MODE] [PROCESSING...]

Modes:
  region        Region select
  full          Entire screen
  all           All screens
  output NAME   Specific output

Processing:
  shadow        Add drop shadow
  resize        Resize to 50%
  annotate      Open in Swappy

Options:
  -h, --help    Show this help
EOF
}

dir="$HOME/Pictures/Screenshots"
file="$dir/screenshot_$(date +%Y%m%d_%H%M%S).png"
swappy_config_home="/tmp/swappy-config"
swappy_config="$swappy_config_home/swappy/config"
mode=()
shadow=false
resize=false
annotate=false

while (($#)); do
  case "$1" in
  -h | --help)
    usage
    exit 0
    ;;
  region)
    mode=()
    ;;
  full | all | last)
    mode=("$1")
    ;;
  output)
    [[ $# -ge 2 ]] || {
      echo "Output name required" >&2
      exit 2
    }

    mode=(output -o "$2")
    shift
    ;;
  shadow)
    shadow=true
    ;;
  resize)
    resize=true
    ;;
  annotate)
    annotate=true
    ;;
  *)
    echo "Unknown argument: $1" >&2
    usage >&2
    exit 2
    ;;
  esac

  shift
done

mkdir -p "$dir"

cmd=(dms screenshot "${mode[@]}")

if ! $shadow && ! $resize && ! $annotate; then
  "${cmd[@]}" -d "$dir"
  exit
fi

"${cmd[@]}" \
  --stdout \
  --no-file \
  --no-clipboard \
  --no-notify >"$file"

[[ -s "$file" ]] || {
  rm -f "$file"
  echo "Capture failed" >&2
  exit 1
}

if $annotate; then
  mkdir -p "${swappy_config%/*}"
  printf '[Default]\nearly_exit=true\n' >"$swappy_config"
  XDG_CONFIG_HOME="$swappy_config_home" swappy -f "$file" -o "$file"
  exit
fi

if $shadow; then
  magick "$file" \
    \( +clone -background black -shadow 60x10+0+5 \) \
    +swap -background none -layers merge +repage "$file"
fi

if $resize; then
  magick "$file" -resize 50% "$file"
fi

wl-copy <"$file"
notify-send -i "$file" "Screenshot" "${file##*/}"
