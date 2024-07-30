#!/usr/bin/env bash

# Function to handle script interruption
on_interrupt() {
    printf "Aborting the script.\n" >&2
    exit 0
}

# Trap SIGINT signal
trap 'on_interrupt' SIGINT

# Function to prompt with fzf
prompt_with_fzf() {
    local prompt_message options selected_option
    prompt_message=$1
    shift
    options=("$@")
    if ! selected_option=$(printf "%s\n" "${options[@]}" | fzf --prompt "$prompt_message" --height 40% --layout=reverse --border); then
        printf "Aborting the script.\n" >&2
        exit 0
    fi
    printf "%s" "$selected_option"
}

# Function to update env.nix with selected setup
update_env_nix() {
    local selected_setup="$1"
    local file_path="./nixos/env.nix"

    sed -i "/setup = \".*\";/c\  setup = \"$selected_setup\";" "$file_path"
    printf "Updated nixos/env.nix with setup: %s\n" "$selected_setup"
}

# Function to handle predefined setups
handle_predefined_setups() {
    local predefined_setups selected_setup
    predefined_setups=("custom" "gaming" "workspace" "multimedia" "serverRemoteDesktop" "server" )
    if ! selected_setup=$(prompt_with_fzf "Select a predefined setup: " "${predefined_setups[@]}"); then
        printf "No setup selected. Exiting.\n" >&2
        exit 1
    fi
    if [[ "$selected_setup" == "server" ]]; then 
        bash ./build/scripts/collectPersonalData.sh
    fi
    update_env_nix "$selected_setup"
    printf "Using predefined setup: %s\n" "$selected_setup"
    printf "Predefined setup selected. Loaded environment variables and skipping builder.\n"
}

# Function to load environment variables from env.nix
load_env_variables() {
    local env_file
    printf "Loading environment variables from env.nix...\n"
    if ! env_file=$(nix-instantiate --eval --strict ./nixos/env.nix); then
        printf "Failed to evaluate env.nix\n" >&2
        exit 1
    fi
    mainUser=$(printf "%s" "$env_file" | grep -oP '(?<=mainUser = ").*?(?=")')
    hostName=$(printf "%s" "$env_file" | grep -oP '(?<=hostName = ").*?(?=")')
    desktop=$(printf "%s" "$env_file" | grep -oP '(?<=desktop = ").*?(?=")')
    displayManager=$(printf "%s" "$env_file" | grep -oP '(?<=displayManager = ").*?(?=")')
    session=$(printf "%s" "$env_file" | grep -oP '(?<=session = ").*?(?=")')
    autoLogin=$(printf "%s" "$env_file" | grep -oP '(?<=autoLogin = ).*?(?=;)')
    domain=$(printf "%s" "$env_file" | grep -oP '(?<=domain = ").*?(?=")')
    email=$(printf "%s" "$env_file" | grep -oP '(?<=email = ").*?(?=")')
    certemail=$(printf "%s" "$env_file" | grep -oP '(?<=certemail = ").*?(?=")')
    printf "Loaded variables: mainUser=%s, hostName=%s, desktop=%s, displayManager=%s, session=%s, autoLogin=%s\n" "$mainUser" "$hostName" "$desktop" "$displayManager" "$session" "$autoLogin"
    printf "Loaded webserver variables: domain=%s, email=%s, certemail=%s\n" "$domain" "$email" "$certemail"
}

main() {
    handle_predefined_setups
    load_env_variables
}

main "$@"