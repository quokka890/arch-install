#!/usr/bin/bash
## Variables ##
DISK=/dev/vda
part1="${DISK}1"
part2="${DISK}2"

## Partitioning ##
umount -A recursive /mnt
sgdisk -Z "${DISK}"
sgdisk -a 2048 -o "${DISK}"
sgdisk --new=1:0+2.1G "${DISK}"
sgdisk --typecode=1:ef00 "${DISK}"
sgdisk --new=2:0:0 "${DISK}"
partprobe "${DISK}"

## Formatting
mkfs.fat -F32 "${part1}"
mkfs.btrfs "${part2}"

## Creating subvolumes ##
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home

## Mount filesystem ##
mount -o compress=zstd,subvol=@ "${part2}" /mnt
mkdir -p /mnt/home
mount -o compress=zstd,subvol=@home "${part2}" /mnt/home
mkdir -p /mnt/efi
mount "${part1}" /mnt/efi

## Installation ##
pacstrap -K /mnt base base-devel linux linux-firmware git btrfs-progs timeshift intel-ucode nvim networkmanager pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber openssh man sudo

## Fstab ##
genfstab -U /mnt >> /mnt/etc/fstab

## Arch-chroot and general config ##
arch-chroot /mnt