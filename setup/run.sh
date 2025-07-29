#!/usr/bin/env bash
set -euo pipefail
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/00_base.sh"
source "$dir/01_chroot.sh"
source "$dir/02_users.sh"
source "$dir/03_bootloader.sh"
systemctl enable NetworkManager