#!/bin/bash

# List of possible keyboard layouts and options
valid_xkb_layouts=("us" "de" "fr" "es" "it" "gb" "jp" "ru")
default_xkb_layout="de"

valid_xkb_options=("eurosign:e" "compose:ralt" "ctrl:nocaps" "caps:swapescape" "altwin:swap_alt_win" "terminate:ctrl_alt_bksp")
default_xkb_options="eurosign:e"

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
    
    if [[ -z "$xkb_layout" || "$xkb_layout" == "env.keyboardLayout" || ! " ${valid_xkb_layouts[@]} " =~ " $xkb_layout " ]]; then
        xkb_layout="$default_xkb_layout"  # Default value
    fi
    printf "%s\n" "$xkb_layout"
}

# Function to get XKB options from NixOS configuration files
get_xkb_options() {
    local xkb_options
    xkb_options=$(grep -rPo '(?<=services\.xserver\.xkb\.options = ")[^"]*(?=")' /etc/nixos | cut -d':' -f2)
    
    if [[ -z "$xkb_options" || "$xkb_options" == "env.keyboardOptions" || ! " ${valid_xkb_options[@]} " =~ " $xkb_options " ]]; then
        xkb_options="$default_xkb_options"  # Default value
    fi
    printf "%s\n" "$xkb_options"
}

# Function to get console keymap from NixOS configuration files
get_console_keymap() {
    local console_keymap
    console_keymap=$(grep -rPo '(?<=console\.keyMap = ")[^"]*(?=")' /etc/nixos)
    
    if [[ -z "$console_keymap" && -f /etc/vconsole.conf ]]; then
        console_keymap=$(grep 'KEYMAP' /etc/vconsole.conf | awk -F= '{print $2}')
    fi
    if [[ -z "$console_keymap" ]]; then
        console_keymap="us"
    fi
    printf "%s\n" "$console_keymap"
}

# Function to update NixOS configuration files
update_nix_files() {
    local lang="$1"
    local xkb_layout="$2"
    local xkb_options="$3"
    local console_keymap="$4"

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
            else
                if grep -q 'keyboardLayout =' "$nix_file"; then
                    sed -i -e "s/keyboardLayout = \".*\";/keyboardLayout = \"us\";/" "$nix_file"
                else
                    sed -i -e "s/keyboardLayout = .*/keyboardLayout = \"us\";/" "$nix_file"
                fi
            fi

            # Update keyboard options
            if [[ -n "$xkb_options" ]]; then
                if grep -q 'keyboardOptions =' "$nix_file"; then
                    sed -i -e "s/keyboardOptions = \".*\";/keyboardOptions = \"$xkb_options\";/" "$nix_file"
                else
                    sed -i -e "s/keyboardOptions = .*/keyboardOptions = \"$xkb_options\";/" "$nix_file"
                fi
            else
                if grep -q 'keyboardOptions =' "$nix_file"; then
                    sed -i -e "s/keyboardOptions = \".*\";/keyboardOptions = \"\";/" "$nix_file"
                else
                    sed -i -e "s/keyboardOptions = .*/keyboardOptions = \"\";/" "$nix_file"
                fi
            fi
        fi
    done
}

# Main function to tie everything together
main() {
    local lang
    local xkb_layout
    local xkb_options
    local console_keymap

    lang=$(get_lang_setting)
    xkb_layout=$(get_xkb_layout)
    xkb_options=$(get_xkb_options)
    console_keymap=$(get_console_keymap)

    update_nix_files "$lang" "$xkb_layout" "$xkb_options" "$console_keymap"

    printf "Settings updated in NixOS configuration files.\n"
    printf "lang: %s\nxkb_layout: %s\nxkb_options: %s\nconsole_keymap: %s\n" "$lang" "$xkb_layout" "$xkb_options" "$console_keymap"
}

main "$@"
