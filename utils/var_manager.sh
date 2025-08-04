#!/usr/bin/env bash
update_env_var() {
    local root
    root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    local key="$1"
    local value="$2"
    local env_file="$root/config/global.env"

    if [[ -z "$key" || -z "$value" ]]; then
        set -a
        # shellcheck disable=SC1091
        source "$root/config/global.env"
        set +a
        return
    fi

    # If the key exists, replace it; otherwise, append it
    if grep -q "^${key}=" "$env_file"; then
        sed -i "s|^${key}=.*|${key}=${value}|" "$env_file"
    else
        echo "${key}=${value}" >> "$env_file"
    fi

    set -a
    source "$root/config/global.env"
    set +a
}