#!/usr/bin/env bash
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
rm -rf /mnt/root/installscript
mkdir -p /mnt/root/installscript
cp -r "$dir/../" /mnt/root/installscript
chmod +x /mnt/root/installscript/setup/run.sh
arch-chroot /mnt /mnt/root/installscript/setup/run.sh