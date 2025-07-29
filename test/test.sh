#!/usr/bin/env bash
set -eo pipefail
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/../setup/run.sh"
setup