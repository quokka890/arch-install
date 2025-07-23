#!/usr/bin/bash
DISK=/dev/sda

## Partitioning ##
umount -A --recursive /mnt
sgdisk -Z "$DISK"

sgdisk -a 2048 -o "$DISK"
sgdisk --new=1:0+2.2150MiB --typecode=1:ef00  "$DISK"
sgdisk --new=2:0:0 "$DISK"