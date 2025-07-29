#!/usr/bin/env bash
set -euo pipefail
install_base() {
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/../config/global.env"
source "$dir/../utils/logger.sh"

log "Installing main packages"
pacstrap -K /mnt base base-devel linux linux-firmware git btrfs-progs timeshift intel-ucode nvim networkmanager pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber openssh man sudo
log "Generating FSTAB"
genfstab -U /mnt >> /mnt/etc/fstab
success "Base system installation complete"
}
