#!/usr/bin/env bash
set -eo pipefail
install_base() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$dir/../config/global.env"
    source "$dir/../utils/logger.sh"

    status "Installing base system"
    pacstrap -K /mnt base base-devel linux linux-firmware git btrfs-progs timeshift intel-ucode nvim networkmanager pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber openssh man sudo
    genfstab -U /mnt >> /mnt/etc/fstab
    success "Base system installation complete"
}
