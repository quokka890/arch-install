#!/usr/bin/env bash
update_env_var() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local key="$1"
    local value="$2"
    local env_file="$dir/../config/global.env"

    # If the key exists, replace it; otherwise, append it
    if grep -q "^${key}=" "$env_file"; then
        sed -i "s|^${key}=.*|${key}=${value}|" "$env_file"
    else
        echo "${key}=${value}" >> "$env_file"
    fi
    set -a
    source "$dir/../config/global.env"
    set +a
}
