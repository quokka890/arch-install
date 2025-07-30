#!/usr/bin/env bash
configure_bootloader() {
    set -euo pipefail

    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$dir/../config/global.env"
    source "$dir/../utils/logger.sh"

    log "Installing systemd-boot to /efi"
    bootctl --esp-path=/efi install

    if [[ -z "${part2:-}" ]]; then
        error "part2 is not defined. Make sure your environment is loaded."
        exit 1
    fi

    ROOT_UUID=$(blkid -s UUID -o value "$part2")
    if [[ -z "$ROOT_UUID" ]]; then
        error "Failed to get UUID for $part2"
        exit 1
    fi

    log "Writing loader configuration"
    cat > /efi/loader/loader.conf <<EOF
default  arch.conf
timeout  4
console-mode max
editor   no
EOF

    cat > /efi/loader/entries/arch.conf <<EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options cryptdevice=UUID=$ROOT_UUID:cryptroot root=/dev/mapper/cryptroot rootflags=subvol=@ rw
EOF

    log "Updating mkinitcpio HOOKS"
    sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect microcode modconf kms keyboard vconsole block sencrypt filesystems fsck)/' "/etc/mkinitcpio.conf"

    log "Creating mkinitcpio preset"
    cat > /etc/mkinitcpio.d/linux.preset <<EOF
PRESETS=('default')
default_image=/efi/initramfs-linux.img
default_kver=/efi/vmlinuz-linux
EOF

    log "Copying kernel and initramfs to /efi"
    cp /boot/vmlinuz-linux /efi/vmlinuz-linux
    cp /boot/initramfs-linux.img /efi/initramfs-linux.img

    log "Generating initramfs"
    mkinitcpio -P

    success "Bootloader configured successfully"
}
