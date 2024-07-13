#!/usr/bin/env bash

# Function to cleanly exit the script on signal
on_interrupt() {
    printf "Aborting the script.\n" >&2
    exit 0
}

# Trap SIGINT signal
trap 'on_interrupt' SIGINT
cd build
# Check if ../nixos/env.nix exists, if not offer predefined setups
if [[ ! -f ../nixos/env.nix ]]; then
    printf "env.nix not found. Offering predefined setups.\n"
    predefined_setups=("gaming" "server" "serverRemoteDesktop" "workspace" "custom")
    if ! selected_setup=$(printf "%s\n" "${predefined_setups[@]}" | fzf --prompt "Select a predefined setup: " --height 40% --layout=reverse --border); then
        printf "No setup selected. Exiting.\n" >&2
        exit 1
    fi

    cp "./setups/$selected_setup.nix" "../nixos/env.nix"
    printf "Using predefined setup: %s\n" "$selected_setup"
else
    # Display current env.nix content
    printf "Current content of ../nixos/env.nix:\n"
    cat ../nixos/env.nix

    # Prompt to use, edit, delete the current env.nix, or abort
    printf "Do you want to (u)se, (e)dit, (d)elete the current env.nix, or (a)bort? (u/e/d/a): "
    read -r action

    case $action in
        u)
            printf "Using existing env.nix.\n"
            ;;
        e)
            printf "Editing env.nix. Please make your changes and save the file.\n"
            ${EDITOR:-nano} ../nixos/env.nix
            ;;
        d)
            printf "Deleting existing env.nix and offering predefined setups.\n"
            rm ../nixos/env.nix

            if ! selected_setup=$(printf "%s\n" "${predefined_setups[@]}" | fzf --prompt "Select a predefined setup: " --height 40% --layout=reverse --border); then
                printf "No setup selected. Exiting.\n" >&2
                exit 1
            fi

            cp "./setups/$selected_setup.nix" "../nixos/env.nix"
            printf "Using predefined setup: %s\n" "$selected_setup"
            ;;
        a)
            printf "Aborting the script.\n"
            exit 0
            ;;
        *)
            printf "Invalid option. Exiting.\n" >&2
            exit 1
            ;;
    esac
fi

# Load environment variables from env.nix
if ! env_file=$(nix-instantiate --eval --strict ../nixos/env.nix); then
    printf "Failed to evaluate env.nix\n" >&2
    exit 1
fi

mainUser=$(printf "%s" "$env_file" | grep -oP '(?<=mainUser = ").*?(?=")')
hostName=$(printf "%s" "$env_file" | grep -oP '(?<=hostName = ").*?(?=")')
desktop=$(printf "%s" "$env_file" | grep -oP '(?<=desktop = ").*?(?=")')
displayManager=$(printf "%s" "$env_file" | grep -oP '(?<=displayManager = ").*?(?=")')
session=$(printf "%s" "$env_file" | grep -oP '(?<=session = ").*?(?=")')
autoLogin=$(printf "%s" "$env_file" | grep -oP '(?<=autoLogin = ).*?(?=;)')
timeZone=$(printf "%s" "$env_file" | grep -oP '(?<=timeZone = ").*?(?=")')
locales=$(printf "%s" "$env_file" | grep -oP '(?<=locales = \[ ").*?(?=" \])')
keyboardLayout=$(printf "%s" "$env_file" | grep -oP '(?<=keyboardLayout = ").*?(?=")')

# Initialize variables if they are empty
mainUser=${mainUser:-"unknown"}
hostName=${hostName:-"unknown"}
desktop=${desktop:-"plasma"}
displayManager=${displayManager:-"sddm"}
session=${session:-"plasmawayland"}
autoLogin=${autoLogin:-"true"}
timeZone=${timeZone:-"Europe/Berlin"}
locales=${locales:-"de_DE.UTF-8"}
keyboardLayout=${keyboardLayout:-"de"}

# Function to prompt with fzf
prompt_with_fzf() {
    local prompt_message=$1
    shift
    local options=("$@")

    local selected_option
    if ! selected_option=$(printf "%s\n" "${options[@]}" | fzf --prompt "$prompt_message" --height 40% --layout=reverse --border); then
        printf "Aborting the script.\n" >&2
        exit 0
    fi

    printf "%s" "$selected_option"
}

# Prompt to change mainUser
printf "Current mainUser: %s\n" "$mainUser"
if [[ "$mainUser" == "unknown" ]]; then
    printf "mainUser is not set. Please enter a value: "
else
    printf "Do you want to change mainUser? Enter new value or press Enter to keep the current value: "
fi
read -r newMainUser

if [[ -n "$newMainUser" ]]; then
    mainUser=$newMainUser
    sed -i -e "s/mainUser = \".*\"/mainUser = \"$mainUser\"/" ../nixos/env.nix
    printf "Updated mainUser to %s in env.nix\n" "$mainUser"
fi

# Prompt to change hostName
printf "Current hostName: %s\n" "$hostName"
if [[ "$hostName" == "unknown" ]]; then
    printf "hostName is not set. Please enter a value: "
else
    printf "Do you want to change hostName? Enter new value or press Enter to keep the current value: "
fi
read -r newHostName

if [[ -n "$newHostName" ]]; then
    hostName=$newHostName
    sed -i -e "s/hostName = \".*\"/hostName = \"$hostName\"/" ../nixos/env.nix
    printf "Updated hostName to %s in env.nix\n" "$hostName"
fi

# Prompt to change Desktop Environment Configuration
selected_desktop=$(prompt_with_fzf "Select Desktop Environment (current: $desktop): " "Keep Current: $desktop" "gnome" "plasma" "xfce")

if [[ "$selected_desktop" != "Keep Current: $desktop" ]]; then
    desktop=$selected_desktop
    sed -i -e "s/desktop = \".*\"/desktop = \"$desktop\"/" ../nixos/env.nix
    printf "Updated desktop to %s in env.nix\n" "$desktop"
fi

# Prompt to change Display Manager Configuration
selected_dm=$(prompt_with_fzf "Select Display Manager (current: $displayManager): " "Keep Current: $displayManager" "sddm" "lightdm" "gdm")

if [[ "$selected_dm" != "Keep Current: $displayManager" ]]; then
    displayManager=$selected_dm
    sed -i -e "s/displayManager = \".*\"/displayManager = \"$displayManager\"/" ../nixos/env.nix
    printf "Updated displayManager to %s in env.nix\n" "$displayManager"
fi

# Prompt to change Session Configuration
selected_session=$(prompt_with_fzf "Select Session (current: $session): " "Keep Current: $session" "plasma" "plasmawayland")

if [[ "$selected_session" != "Keep Current: $session" ]]; then
    session=$selected_session
    sed -i -e "s/session = \".*\"/session = \"$session\"/" ../nixos/env.nix
    printf "Updated session to %s in env.nix\n" "$session"
fi

# Prompt to change Auto Login Configuration
selected_autoLogin=$(prompt_with_fzf "Select Auto Login (current: $autoLogin): " "true" "false")

if [[ "$selected_autoLogin" != "$autoLogin" ]]; then
    autoLogin=$selected_autoLogin
    sed -i -e "s/autoLogin = .*/autoLogin = $autoLogin;/" ../nixos/env.nix
    printf "Updated autoLogin to %s in env.nix\n" "$autoLogin"
fi

# Prompt to change TimeZone Configuration
selected_timezone=$(prompt_with_fzf "Select TimeZone (current: $timeZone): " "Keep Current: $timeZone" "Europe/Berlin" "America/New_York" "Asia/Tokyo" "Australia/Sydney" "UTC")

if [[ "$selected_timezone" != "Keep Current: $timeZone" ]]; then
    timeZone=$selected_timezone
    sed -i -e "s/timeZone = \".*\"/timeZone = \"$timeZone\"/" ../nixos/env.nix
    printf "Updated timeZone to %s in env.nix\n" "$timeZone"
fi

# Prompt to change Locales Configuration
selected_locales=$(prompt_with_fzf "Select Locales (current: $locales): " "Keep Current: $locales" "en_US.UTF-8" "de_DE.UTF-8" "fr_FR.UTF-8" "es_ES.UTF-8" "it_IT.UTF-8")

if [[ "$selected_locales" != "Keep Current: $locales" ]]; then
    locales=$selected_locales
    sed -i -e "s/locales = \[ \".*\" \]/locales = \[ \"$locales\" \]/" ../nixos/env.nix
    printf "Updated locales to %s in env.nix\n" "$locales"
fi

# Prompt to change Keyboard Layout Configuration
selected_keyboard_layout=$(prompt_with_fzf "Select Keyboard Layout (current: $keyboardLayout): " "Keep Current: $keyboardLayout" "us" "uk" "fr" "es" "it" "jp" "ru" "zh" "kr" "br")

if [[ "$selected_keyboard_layout" != "Keep Current: $keyboardLayout" ]]; then
    keyboardLayout=$selected_keyboard_layout
    sed -i -e "s/keyboardLayout = \".*\"/keyboardLayout = \"$keyboardLayout\"/" ../nixos/env.nix
    printf "Updated keyboardLayout to %s in env.nix\n" "$keyboardLayout"
fi

cd ..