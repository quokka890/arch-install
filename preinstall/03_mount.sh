#!/usr/bin/env bash
set -euo pipefail
mount_filesystem() {
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/../config/global.env"
source "$dir/../utils/logger.sh"

log "Mounting filesystem"
mount -o compress=zstd,subvol=@ "${part2}" /mnt
mkdir -p /mnt/home
mount -o compress=zstd,subvol=@home "${part2}" /mnt/home
mkdir -p /mnt/efi
mount "${part1}" /mnt/efi
success "Mounted filesystem successfully"
}
