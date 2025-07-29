#!/usr/bin/env bash
set -eo pipefail
configure_users() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$dir/../config/global.env"
    log "Setting up host and users"
    
    touch /etc/hostname
    echo "$HOSTNAME" >> /etc/hostname

    touch /etc/hosts
    cat > /etc/hosts <<-EOF
127.0.0.1 localhost
::1 localhost
127.0.1.1 "$HOSTNAME"
EOF
    passwd
    useradd -mG wheel "$user"
    passwd "$user"
    sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
}