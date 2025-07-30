#!/usr/bin/env bash
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/02_users.sh"
source "$dir/03_bootloader.sh"

setup_bootloader
