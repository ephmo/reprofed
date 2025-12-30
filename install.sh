#!/usr/bin/env bash
set -euo pipefail
shopt -s globstar nullglob

script_path="$(readlink -f "${BASH_SOURCE[0]}")"
script_dir="$(dirname "$script_path")"

if [ "$EUID" -ne 0 ]; then
  echo "❌ This script must be run as root or with sudo."
  exit 1
fi

source /etc/os-release

distro_id="$ID"

if [[ "$distro_id" != "fedora" ]]; then
  echo "❌ Unsupported distribution: $distro_id"
  exit 1
fi

func_install() {
  if ! command -v yq > /dev/null 2>&1; then
    dnf5 install -y yq
  fi

  install -d -m 755 /opt/reprofed
  install -d -m 755 /opt/reprofed/profiles

  install -m 644 "$script_dir"/src/profiles/* /opt/reprofed/profiles/
  install -m 755 -T "$script_dir"/src/reprofed.sh /opt/reprofed/reprofed.sh
  install -m 644 -T "$script_dir"/src/VERSION /opt/reprofed/VERSION

  ln -sf /opt/reprofed/reprofed.sh /usr/bin/reprofed
}

func_remove() {
  rm -f /usr/bin/reprofed
  rm -rf /opt/reprofed/
}

func_help() {
  cat << EOF
Usage:
  $0 [OPTION]

Options:
EOF

  cat << EOF | column -t -s $'\t'
  -i, --install	Install the application
  -u, --update	Update the application
  -r, --remove	Remove the application
  -h, --help	Show this help message
EOF

  cat << EOF

Examples:
  reprofed -i
  reprofed --update
  reprofed --remove
EOF
}

func_error_args() {
  echo "❌ Invalid argument." >&2
  exit 1
}

func_main() {
  if [[ $# -eq 0 ]]; then
    func_help
    exit 0
  fi

  case "$1" in
    -i | --install) [[ $# -eq 1 ]] && func_remove && func_install || func_error_args ;;

    -u | --update) [[ $# -eq 1 ]] && func_install || func_error_args ;;

    -r | --remove) [[ $# -eq 1 ]] && func_remove || func_error_args ;;

    -h | --help) [[ $# -eq 1 ]] && func_help || func_error_args ;;

    *) func_error_args ;;
  esac
}

func_main "$@"

echo "✅ Installation completed successfully."
