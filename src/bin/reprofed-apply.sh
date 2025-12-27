#!/usr/bin/env bash
set -euo pipefail
shopt -s globstar nullglob

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

source "$SCRIPT_DIR"/../core/constants.sh

LOG_FILE="/var/log/$APP_NAME.log"

: > "$LOG_FILE"

msg_success() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') SUCCESS: $1" >> "$LOG_FILE"
}

msg_error() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') ERROR: $1" >> "$LOG_FILE"
}
