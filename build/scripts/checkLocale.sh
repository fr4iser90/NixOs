#!/bin/bash

# Function to get LANG setting from environment
get_lang_setting() {
    local lang
    lang=$(printf '%s' "$LANG")
    printf "%s\n" "$lang"
}

# Function to get XKB layout from NixOS configuration files
get_xkb_layout() {
    local xkb_layout
    xkb_layout=$(grep -rPo '(?<=services\.xserver\.xkb\.layout = ")[^"]*(?=")' /etc/nixos | cut -d':' -f2)
    printf "%s\n" "$xkb_layout"
}

# Function to get console keymap from NixOS configuration files
get_console_keymap() {
    local console_keymap
    console_keymap=$(grep -rPo '(?<=console\.keyMap = ")[^"]*(?=")' /etc/nixos)
    if [[ -z "$console_keymap" && -f /etc/vconsole.conf ]]; then
        console_keymap=$(grep 'KEYMAP' /etc/vconsole.conf | awk -F= '{print $2}')
    fi
    printf "%s\n" "$console_keymap"
}

# Function to update NixOS configuration files
update_nix_files() {
    local lang="$1"
    local xkb_layout="$2"
    local console_keymap="$3"

    printf "Current working directory: %s\n" "$(pwd)"
    printf "NixOS setup files found in ./setups/: \n"
    ls -l ./setups/*.nix

    for nix_file in ./build/setups/*.nix; do
        if [[ -f "$nix_file" ]]; then
            printf "Updating file: %s\n" "$nix_file"

            # Update locales
            if grep -q 'locales = \[' "$nix_file"; then
                sed -i -e "s/locales = \[.*\];/locales = \[ \"$lang\" \];/" "$nix_file"
            else
                sed -i -e "s/locales = .*/locales = \[ \"$lang\" \];/" "$nix_file"
            fi

            # Update keyboard layout (prefer xkb_layout, fallback to console_keymap)
            if [[ -n "$xkb_layout" ]]; then
                if grep -q 'keyboardLayout =' "$nix_file"; then
                    sed -i -e "s/keyboardLayout = \".*\";/keyboardLayout = \"$xkb_layout\";/" "$nix_file"
                else
                    sed -i -e "s/keyboardLayout = .*/keyboardLayout = \"$xkb_layout\";/" "$nix_file"
                fi
            elif [[ -n "$console_keymap" ]]; then
                if grep -q 'keyboardLayout =' "$nix_file"; then
                    sed -i -e "s/keyboardLayout = \".*\";/keyboardLayout = \"$console_keymap\";/" "$nix_file"
                else
                    sed -i -e "s/keyboardLayout = .*/keyboardLayout = \"$console_keymap\";/" "$nix_file"
                fi
            fi
        fi
    done
}

# Main function to tie everything together
main() {
    local lang
    local xkb_layout
    local console_keymap

    lang=$(get_lang_setting)
    xkb_layout=$(get_xkb_layout)
    console_keymap=$(get_console_keymap)

    update_nix_files "$lang" "$xkb_layout" "$console_keymap"

    printf "Settings updated in NixOS configuration files.\n"
    printf "lang: %s\nxkb_layout: %s\nconsole_keymap: %s\n" "$lang" "$xkb_layout" "$console_keymap"
}

main "$@"
