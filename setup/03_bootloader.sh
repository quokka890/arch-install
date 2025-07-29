#!/usr/bin/env bash
setup_bootloader() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$dir/../config/global.env"
    source "$dir/../utils/logger.sh"
    log "Configuring bootloader"
    bootctl install
    ROOT_UUID=$(blkid -s UUID -o value "$part2")
    log "Configuring entries"
    touch /efi/loader/loader.conf
    cat > /efi/loader/loader.conf <<EOF
default  arch.conf
timeout  4
console-mode max
editor   no
EOF

    touch /efi/loader/entries/arch.conf
    cat > /efi/loader/entries/arch.conf <<EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options cryptdevice=UUID=$ROOT_UUID:cryptroot root=/dev/mapper/cryptroot rootflags=subvol=@ rw
EOF

    log "Configuring mkinitcpio.conf"
    sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt filesystems fsck)/' "/etc/mkinitcpio.conf"
    
    cat > /etc/mkinitcpio.d/linux.preset <<EOF
PRESETS=('default')
default_image=/efi/initramfs-linux.img
default_kver=/efi/vmlinuz-linux
EOF

    cp /boot/vmlinuz-linux /efi
    cp /boot/initramfs-linux.img /efi
    mkinitcpio -P
}