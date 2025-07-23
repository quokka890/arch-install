#!/usr/bin/bash
## Variables ##
DISK=/dev/sda

## Preliminary setup ##
verifyUEFI(){
    UEFI=$(cat /sys/firmware/efi/fw_platform_size)
    if [  "$UEFI" -eq 32 ]; then
    exit 1
    else 
    exit 0
    fi
}
loadkeys us
timedatectl set-timezone Portugal    
timedatectl set-ntp true
pacman -S --noconfirm archlinux-keyring
pacman -S --noconfirm --needed reflector
reflector --sort rate --protocol https --country Spain,France,Portugal --verbose --save /etc/pacman.d/mirrorlist
pacman -S --noconfirm --needed gptfdisk btrfs-progs

## Partitioning ##
umount -A recursive /mnt
sgdisk -Z "${DISK}"

sgdisk -a 2048 -o "${DISK}"
sgdisk --new=1:0+2.1G 
sgdisk --typecode=1:ef00
sgdisk --new=2:0:0
part1="${DISK}p1"
part2="${DISK}p2"

## Formatting
mkfs.fat -F32 "{$part1}"
mkfs.btrfs "{$part2}"
partprobe "${DISK}"

## Creating subvolumes ##
createsubvolumes() {
    btrfs subvolume create /mnt/@
    btrfs subvolume create /mnt/@home
}

mountsubvol() {
    mount -o compress=zstd,subvol=@ "{$part2}" /mnt
    mkdir -p /mnt/home
    mount -o compress=zstd,subvol=@home "{$part2}" /mnt/home
    mkdir -p /mnt/efi
    mount "{$part1}" /mnt/efi
}