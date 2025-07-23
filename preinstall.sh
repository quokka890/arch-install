#!/usr/bin/bash
## Variables ##
DISK=/dev/sda

## Partitioning ##
umount -A recursive /mnt
sgdisk -Z "${DISK}"

sgdisk -a 2048 -o "${DISK}"
sgdisk --new=1:0+2.1G "${DISK}"
sgdisk --typecode=1:ef00 "${DISK}"
sgdisk --new=2:0:0 "${DISK}"
partprobe "${DISK}"
part1="${DISK}1"
part2="${DISK}2"

## Formatting
mkfs.fat -F32 "${part1}"
mkfs.btrfs "${part2}"

## Creating subvolumes ##
createsubvolumes() {
    btrfs subvolume create /mnt/@
    btrfs subvolume create /mnt/@home
}

mountsubvol() {
    mount -o compress=zstd,subvol=@ "${part2}" /mnt
    mkdir -p /mnt/home
    mount -o compress=zstd,subvol=@home "${part2}" /mnt/home
    mkdir -p /mnt/efi
    mount "${part1}" /mnt/efi
}