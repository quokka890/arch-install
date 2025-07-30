#!/usr/bin/env bash
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p /mnt/root/installscript
cp -r "$dir" /mnt/root/installscript
chmod +x /mnt/root/installscript/setup/run.sh
sudo arch-chroot /mnt /root/installscript/setup/run.sh