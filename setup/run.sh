#!/usr/bin/env bash
set -euo pipefail
setup() {
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$dir/00_base.sh"
    source "$dir/01_chroot.sh"
    source "$dir/02_users.sh"
    source "$dir/03_bootloader.sh"
    source "$dir/04_finish.sh"
    install_base
    chroot
    configure_users
    configure_bootloader
    success "Setup complete!"
    finish
}