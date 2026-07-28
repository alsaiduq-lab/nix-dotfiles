#!/usr/bin/env bash
set -euo pipefail

RECORDINGS_DIR="${RECORDINGS_DIR:-$HOME/Videos/Recordings}"
STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/screen-record"
PID_FILE="$STATE_DIR/pid"
PATH_FILE="$STATE_DIR/path"
FLAGS_FILE="$STATE_DIR/flags"
MODE="fullscreen"
MIC=false
COMPRESS=false
timestamp="$(date +'%Y-%m-%d_%H-%M-%S')"
filepath="$RECORDINGS_DIR/${MODE}_${timestamp}.mp4"

usage() {
  cat <<EOF
Usage: $(basename "$0") [MODE] [OPTIONS]

Modes:
  fullscreen    Record fullscreen
  region        Select region before recording

Options:
  --mic         Include microphone audio
  --compress    Compress after recording
  -h, --help    Show this help

Running the command again stops the current recording.
Passing --compress while stopping enables compression.
EOF
}

notify() {
  if command -v notify-send &>/dev/null; then
    notify-send -t 3000 -a "Screen Recorder" "$1" "$2"
  else
    printf '>> %s: %s\n' "$1" "$2"
  fi
}

cleanup() {
  rm -f "$PID_FILE" "$PATH_FILE" "$FLAGS_FILE"
}

get_recording_pid() {
  local pid

  [[ -f "$PID_FILE" ]] || return 1
  read -r pid <"$PID_FILE" || return 1
  [[ "$pid" =~ ^[0-9]+$ ]] || return 1

  kill -0 "$pid" 2>/dev/null || return 1
  printf '%s\n' "$pid"
}

compress_recording() {
  local input="$1"
  local output="${input%.mp4}.tmp.mp4"
  local encoder="libx264"

  if ffmpeg -hide_banner -encoders 2>/dev/null | grep -q 'h264_nvenc'; then
    encoder="h264_nvenc"
  fi

  printf '\e[34mCompressing with %s...\e[0m\n' "$encoder"

  if [[ "$encoder" == "h264_nvenc" ]]; then
    ffmpeg -y -i "$input" \
      -c:v h264_nvenc \
      -preset p5 \
      -tune hq \
      -rc vbr \
      -cq 24 \
      -pix_fmt yuv420p \
      -c:a aac \
      -b:a 160k \
      -movflags +faststart \
      "$output"
  else
    ffmpeg -y -i "$input" \
      -c:v libx264 \
      -preset slow \
      -crf 24 \
      -pix_fmt yuv420p \
      -c:a aac \
      -b:a 160k \
      -movflags +faststart \
      "$output"
  fi

  if [[ -s "$output" ]]; then
    mv -- "$output" "$input"
  else
    rm -f -- "$output"
    return 1
  fi
}

finish_recording() {
  local filepath=""

  [[ -f "$PATH_FILE" ]] && read -r filepath <"$PATH_FILE"

  if [[ -f "$filepath" ]]; then
    if grep -qx 'compress' "$FLAGS_FILE" 2>/dev/null; then
      compress_recording "$filepath"
    fi

    notify "Recording Saved" "$(basename "$filepath")"
    printf '\e[32mSaved: %s\e[0m\n' "$filepath"
  else
    notify "Recording Error" "No output file found"
    printf '\e[31mNo output file found\e[0m\n'
  fi

  cleanup
}

stop_recording() {
  local pid="$1"
  local timeout=80

  printf '\e[31mStopping recording PID %s...\e[0m\n' "$pid"
  kill -SIGINT "$pid" 2>/dev/null || true

  while kill -0 "$pid" 2>/dev/null && ((timeout-- > 0)); do
    sleep 0.1
  done
}

while (($#)); do
  case "$1" in
  fullscreen | region)
    MODE="$1"
    ;;
  --mic)
    MIC=true
    ;;
  --compress)
    COMPRESS=true
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    printf 'Unknown argument: %s\n\n' "$1" >&2
    usage >&2
    exit 1
    ;;
  esac

  shift
done

mkdir -p "$STATE_DIR" "$RECORDINGS_DIR"

if CURRENT_PID="$(get_recording_pid)"; then
  $COMPRESS && printf 'compress\n' >"$FLAGS_FILE"
  stop_recording "$CURRENT_PID"
  exit 0
fi

cleanup

GSR_ARGS=(
  -f 60
  -q very_high
  -k h264
  -ac aac
  -ab 160
  -cr limited
  -c mp4
  -a default_output
)

$MIC && GSR_ARGS+=(-a default_input)

case "$MODE" in
fullscreen)
  GSR_ARGS=(-w screen "${GSR_ARGS[@]}")
  ;;
region)
  selection="$(slurp)" || exit 1
  IFS=', x' read -r x y width height <<<"$selection"

  GSR_ARGS=(
    -w region
    -region "${width}x${height}+${x}+${y}"
    "${GSR_ARGS[@]}"
  )
  ;;
esac

GSR_ARGS+=(-o "$filepath")

printf '%s\n' "$filepath" >"$PATH_FILE"
$COMPRESS && printf 'compress\n' >"$FLAGS_FILE"

gsr_pid=""

handle_signal() {
  [[ -n "$gsr_pid" ]] && kill -SIGINT "$gsr_pid" 2>/dev/null || true
}

trap handle_signal SIGINT SIGTERM
trap cleanup EXIT

printf '\e[32mRecording Started: %s\e[0m\n' "$MODE"

gpu-screen-recorder "${GSR_ARGS[@]}" &
gsr_pid="$!"

printf '%s\n' "$gsr_pid" >"$PID_FILE"

wait "$gsr_pid" || true

trap - EXIT
finish_recording
