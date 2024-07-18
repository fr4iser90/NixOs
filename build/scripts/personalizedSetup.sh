#!/usr/bin/env bash

# Function to handle script interruption
on_interrupt() {
    printf "Aborting the script.\n" >&2
    exit 0
}

# Trap SIGINT signal
trap 'on_interrupt' SIGINT

# Function to change directory to build
change_to_build_dir() {
    printf "Changing to build directory...\n"
    cd build || { printf "Failed to change to build directory\n" >&2; exit 1; }
}

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

# Function to load current session from env.nix
load_current_session() {
    local session_line
    session_line=$(grep -E '^session\s*=' ../nixos/env.nix)
    session=${session_line#*= }
    session=${session//\"/}
    printf "Loaded current session: %s\n" "$session"
}

# Main function for session configuration
configure_session() {
    local selected_type selected_session
    load_current_session
    if [[ "$desktop" == "gnome" || "$desktop" == "xfce" ]]; then
        selected_session="$desktop"
    else
        selected_type=$(prompt_with_fzf "Select Session Type (current: $session): " "Keep Current: $session" "X11" "Wayland")
        if [[ "$selected_type" == "X11" ]]; then
            selected_session="plasma"
        elif [[ "$selected_type" == "Wayland" ]]; then
            selected_session="plasmawayland"
        else
            selected_session="$session"
        fi
    fi
    if [[ "$selected_session" != "$session" ]]; then
        session=$selected_session
        sed -i -e "s/session = \".*\"/session = \"$session\"/" ../nixos/env.nix
        printf "Updated session to %s in env.nix\n" "$session"
    fi
}

# Function to handle the existing env.nix file
handle_existing_env_nix() {
    local action
    printf "Current content of ../nixos/env.nix:\n"
    cat ../nixos/env.nix
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
            ../predefined_setup.sh
            exit 0
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
}

# Function to load environment variables from env.nix
load_env_variables() {
    local env_file
    printf "Loading environment variables from env.nix...\n"
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
    printf "Loaded variables: mainUser=%s, hostName=%s, desktop=%s, displayManager=%s, session=%s, autoLogin=%s\n" "$mainUser" "$hostName" "$desktop" "$displayManager" "$session" "$autoLogin"
}

# Function to initialize variables if they are empty
initialize_variables() {
    mainUser=${mainUser:-"unknown"}
    hostName=${hostName:-"unknown"}
    desktop=${desktop:-"plasma"}
    displayManager=${displayManager:-"sddm"}
    session=${session:-"plasmawayland"}
    autoLogin=${autoLogin:-"true"}
    printf "Initialized variables: mainUser=%s, hostName=%s, desktop=%s, displayManager=%s, session=%s, autoLogin=%s\n" "$mainUser" "$hostName" "$desktop" "$displayManager" "$session" "$autoLogin"
}

# Function to prompt and update variable
prompt_and_update_variable() {
    local current_value prompt_message new_value variable_name
    current_value=$1
    prompt_message=$2
    variable_name=$3
    printf "%s\n" "$prompt_message"
    read -r new_value
    if [[ -n "$new_value" ]]; then
        eval "$variable_name=$new_value"
        sed -i -e "s/$variable_name = \".*\"/$variable_name = \"$new_value\"/" ../nixos/env.nix
        printf "Updated %s to %s in env.nix\n" "$variable_name" "$new_value"
    fi
}

# Function to prompt and update selection
prompt_and_update_selection() {
    local current_value options prompt_message selected_option variable_name
    current_value=$1
    prompt_message=$2
    shift 2
    options=("$@")
    selected_option=$(prompt_with_fzf "$prompt_message (current: $current_value): " "Keep Current: $current_value" "${options[@]}")
    if [[ "$selected_option" != "Keep Current: $current_value" ]]; then
        eval "$variable_name=$selected_option"
        sed -i -e "s/$variable_name = \".*\"/$variable_name = \"$selected_option\"/" ../nixos/env.nix
        printf "Updated %s to %s in env.nix\n" "$variable_name" "$selected_option"
    fi
}

main() {
    change_to_build_dir

    if [[ ! -f ../nixos/env.nix ]]; then
        printf "env.nix not found. Please run predefined_setup.sh first.\n"
        exit 1
    else
        handle_existing_env_nix
    fi

    load_env_variables
    initialize_variables
    prompt_and_update_variable "$mainUser" $'Current mainUser: '"$mainUser"$'\nDo you want to change mainUser? Enter new value or press Enter to keep the current value: ' "mainUser"
    prompt_and_update_variable "$hostName" $'Current hostName: '"$hostName"$'\nDo you want to change hostName? Enter new value or press Enter to keep the current value: ' "hostName"
    prompt_and_update_selection "$desktop" "Select Desktop Environment" "gnome" "plasma" "xfce"
    prompt_and_update_selection "$displayManager" "Select Display Manager" "sddm" "lightdm" "gdm"
    configure_session
    prompt_and_update_selection "$autoLogin" "Select Auto Login" "true" "false"

    cd ..
}

main "$@"
