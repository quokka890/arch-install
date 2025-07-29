#!/usr/bin/env bash
set -euo pipefail
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/../functions/preinstall/preliminary_checks.sh"
source "$dir/01_partition.sh"