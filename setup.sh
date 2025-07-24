#!/usr/bin/bash
## Arch-chroot and general config ##
arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
hwclock --systohc