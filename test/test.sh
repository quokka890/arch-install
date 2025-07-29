#!/usr/bin/env bash
set -eo pipefail
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/../preinstall/04_base.sh"
setup