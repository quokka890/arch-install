#!/usr/bin/env bash
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/02_users.sh"
source "$dir/03_bootloader.sh"
source "$dir/04_finish.sh"
configure_users
configure_bootloader
finish
