#!/usr/bin/env bash

# Prompt user to choose predefined or personalized setup using fzf
choice=$(printf "Predefined\nPersonalized" | fzf --prompt "Choose setup type: " --height 40% --layout=reverse --border)

if [[ "$choice" == "Predefined" ]]; then
    export SETUP_TYPE="predefined"
    echo "Predefined setup selected."
elif [[ "$choice" == "Personalized" ]]; then
    export SETUP_TYPE="personalized"
    echo "Personalized setup selected."
else
    echo "Invalid choice. Aborting."
    exit 1
fi
