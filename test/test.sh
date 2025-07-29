#!/usr/bin/env bash
set -eo pipefail
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/../setup/03_bootloader.sh"
setup_bootloader