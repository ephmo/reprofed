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

source "$SCRIPT_DIR"/../core/check_distro_id.sh

if ! check_distro_id; then
  msg_error "Unsupported distribution."
  exit 1
fi

source "$SCRIPT_DIR"/../core/check_distro_version.sh

if ! check_distro_version; then
  msg_error "Fedora version ${DISTRO_VERSION_ID:-unknown} is not supported."
  exit 1
fi
