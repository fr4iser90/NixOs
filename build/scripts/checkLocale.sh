#!/bin/bash

OUTPUT_FILE="./locale_and_keyboard_settings.txt"

# Function to retrieve settings
retrieve_settings() {
    local lang
    local xkb_layout
    local console_keymap

    # Get LANG setting from environment
    lang=$(echo $LANG)

    # Try to get XKB layout from common X11 config files
    if [ -f /etc/X11/xorg.conf.d/00-keyboard.conf ]; then
        xkb_layout=$(grep 'Option "XkbLayout"' /etc/X11/xorg.conf.d/00-keyboard.conf | awk '{print $4}' | tr -d '"')
    elif [ -f /etc/X11/xorg.conf.d/10-keyboard.conf ]; then
        xkb_layout=$(grep 'Option "XkbLayout"' /etc/X11/xorg.conf.d/10-keyboard.conf | awk '{print $4}' | tr -d '"')
    elif [ -f /etc/X11/xorg.conf ]; then
        xkb_layout=$(grep 'Option "XkbLayout"' /etc/X11/xorg.conf | awk '{print $4}' | tr -d '"')
    fi

    # Get XKB layout from NixOS configuration.nix
    if [ -f /etc/nixos/configuration.nix ]; then
        xkb_layout_nixos=$(grep -Po '(?<=services\.xserver\.xkb\.layout = ").*?(?=")' /etc/nixos/configuration.nix)
        if [ -n "$xkb_layout_nixos" ]; then
            xkb_layout="$xkb_layout_nixos"
        fi
        console_keymap_nixos=$(grep -Po '(?<=console\.keyMap = ").*?(?=")' /etc/nixos/configuration.nix)
        if [ -n "$console_keymap_nixos" ]; then
            console_keymap="$console_keymap_nixos"
        fi
    fi

    # Get console keymap from vconsole.conf
    if [ -f /etc/vconsole.conf ]; then
        console_keymap_vconsole=$(grep 'KEYMAP' /etc/vconsole.conf | awk -F= '{print $2}')
        if [ -n "$console_keymap_vconsole" ]; then
            console_keymap="$console_keymap_vconsole"
        fi
    fi

    {
        printf "Locale Settings:\n"
        printf "LANG: %s\n" "$lang"
        printf "\nKeyboard Layout Settings:\n"
        printf "XKB Layout: %s\n" "$xkb_layout"
        printf "Console KeyMap: %s\n" "$console_keymap"
    } >> "$OUTPUT_FILE"
}

# Clear previous output file
> "$OUTPUT_FILE"

# Retrieve and print the settings
retrieve_settings

# Check if output file is not empty and print content
if [[ -s "$OUTPUT_FILE" ]]; then
    cat "$OUTPUT_FILE"
else
    printf "No locale or keyboard settings found.\n" >&2
fi
