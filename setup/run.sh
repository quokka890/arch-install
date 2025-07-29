#!/usr/bin/env bash
set -eo pipefail
setup() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$dir/00_base.sh"
    source "$dir/01_locale.sh"
    source "$dir/02_users.sh"
    source "$dir/03_bootloader.sh"
    source "$dir/04_finish.sh"
    install_base
    arch-chroot /mnt <<EOF
setup_locale
configure_users
configure_bootloader
success "Setup complete!"
finish
EOF
}