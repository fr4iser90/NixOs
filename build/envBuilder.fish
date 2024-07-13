#!/usr/bin/env fish

# Funktion zum sauberen Beenden des Skripts bei Signal
function on_interrupt --on-signal SIGINT
  echo "Aborting the script."
  exit 0
end

# Check if ../nixos/env.nix exists, if not offer predefined setups
if not test -f ../nixos/env.nix
  echo "env.nix not found. Offering predefined setups."
  set -l predefined_setups "gaming" "server" "serverRemoteDesktop" "workspace" "predefinedCustom"
  set -l selected_setup (printf "%s\n" $predefined_setups | fzf --prompt "Select a predefined setup: " --height 40% --layout=reverse --border)

  if test -z "$selected_setup"
    echo "No setup selected. Exiting."
    exit 1
  end

  cp ./setups/$selected_setup.nix ../nixos/env.nix
  echo "Using predefined setup: $selected_setup"
else
  # Display current env.nix content
  echo "Current content of ../nixos/env.nix:"
  cat ../nixos/env.nix

  # Prompt to use, edit, delete the current env.nix, or abort
  echo "Do you want to (u)se, (e)dit, (d)elete the current env.nix, or (a)bort? (u/e/d/a):"
  read -l action

  switch $action
    case u
      echo "Using existing env.nix."
    case e
      echo "Editing env.nix. Please make your changes and save the file."
      $EDITOR ../nixos/env.nix
    case d
      echo "Deleting existing env.nix and offering predefined setups."
      rm ../nixos/env.nix

      set -l predefined_setups "gaming" "server" "serverRemoteDesktop" "workspace" "predefinedCustom"
      set -l selected_setup (printf "%s\n" $predefined_setups | fzf --prompt "Select a predefined setup: " --height 40% --layout=reverse --border)

      if test -z "$selected_setup"
        echo "No setup selected. Exiting."
        exit 1
      end

      cp ./setups/$selected_setup.nix ../nixos/env.nix
      echo "Using predefined setup: $selected_setup"
    case a
      echo "Aborting the script."
      exit 0
    case '*'
      echo "Invalid option. Exiting."
      exit 1
  end
end

# Load environment variables from env.nix
set -l env_file (nix-instantiate --eval --strict ../nixos/env.nix)

set -lx mainUser (echo $env_file | grep -oP '(?<=mainUser = ").*?(?=")')
set -lx hostName (echo $env_file | grep -oP '(?<=hostName = ").*?(?=")')
set -lx desktop (echo $env_file | grep -oP '(?<=desktop = ").*?(?=")')
set -lx displayManager (echo $env_file | grep -oP '(?<=displayManager = ").*?(?=")')
set -lx session (echo $env_file | grep -oP '(?<=session = ").*?(?=")')
set -lx autoLogin (echo $env_file | grep -oP '(?<=autoLogin = ).*?(?=;)')
set -lx timeZone (echo $env_file | grep -oP '(?<=timeZone = ").*?(?=")')
set -lx locales (echo $env_file | grep -oP '(?<=locales = \[ ").*?(?=" \])')
set -lx keyboardLayout (echo $env_file | grep -oP '(?<=keyboardLayout = ").*?(?=")')

# Initialize variables if they are empty
if test -z "$mainUser"
  set mainUser "unknown"
end

if test -z "$hostName"
  set hostName "unknown"
end

if test -z "$desktop"
  set desktop "plasma"
end

if test -z "$displayManager"
  set displayManager "sddm"
end

if test -z "$session"
  set session "plasmawayland"
end

if test -z "$autoLogin"
  set autoLogin "true"
end

if test -z "$timeZone"
  set timeZone "Europe/Berlin"
end

if test -z "$locales"
  set locales "de_DE.UTF-8"
end

if test -z "$keyboardLayout"
  set keyboardLayout "de"
end

# Funktion zur Abfrage und Auswahl mit fzf
function prompt_with_fzf
  set -l prompt_message $argv[1]
  set -l options $argv[2..-1]

  set -l selected_option (printf "%s\n" $options | fzf --prompt "$prompt_message" --height 40% --layout=reverse --border)
  if test "$status" -ne 0
    echo "Aborting the script."
    exit 0
  end

  echo $selected_option
end

# Prompt to change mainUser
echo "Current mainUser: $mainUser"
if test "$mainUser" = "unknown"
  echo "mainUser is not set. Please enter a value:"
else
  echo "Do you want to change mainUser? Enter new value or press Enter to keep the current value:"
end
read -l newMainUser

if test -n "$newMainUser"
  set mainUser $newMainUser
  sed -i -e "s/mainUser = \".*\"/mainUser = \"$mainUser\"/" ../nixos/env.nix
  echo "Updated mainUser to $mainUser in env.nix"
end

# Prompt to change hostName
echo "Current hostName: $hostName"
if test "$hostName" = "unknown"
  echo "hostName is not set. Please enter a value:"
else
  echo "Do you want to change hostName? Enter new value or press Enter to keep the current value:"
end
read -l newHostName

if test -n "$newHostName"
  set hostName $newHostName
  sed -i -e "s/hostName = \".*\"/hostName = \"$hostName\"/" ../nixos/env.nix
  echo "Updated hostName to $hostName in env.nix"
end

# Prompt to change Desktop Environment Configuration
set selected_desktop (prompt_with_fzf "Select Desktop Environment (current: $desktop): " "Keep Current: $desktop" "gnome" "plasma" "xfce")

if test "$selected_desktop" != "Keep Current: $desktop"
  set desktop $selected_desktop
  sed -i -e "s/desktop = \".*\"/desktop = \"$desktop\"/" ../nixos/env.nix
  echo "Updated desktop to $desktop in env.nix"
end

# Prompt to change Display Manager Configuration
set selected_dm (prompt_with_fzf "Select Display Manager (current: $displayManager): " "Keep Current: $displayManager" "sddm" "lightdm" "gdm")

if test "$selected_dm" != "Keep Current: $displayManager"
  set displayManager $selected_dm
  sed -i -e "s/displayManager = \".*\"/displayManager = \"$displayManager\"/" ../nixos/env.nix
  echo "Updated displayManager to $displayManager in env.nix"
end

# Prompt to change Session Configuration
set selected_session (prompt_with_fzf "Select Session (current: $session): " "Keep Current: $session" "plasma" "plasmawayland")

if test "$selected_session" != "Keep Current: $session"
  set session $selected_session
  sed -i -e "s/session = \".*\"/session = \"$session\"/" ../nixos/env.nix
  echo "Updated session to $session in env.nix"
end

# Prompt to change Auto Login Configuration
set selected_autoLogin (prompt_with_fzf "Select Auto Login (current: $autoLogin): " "true" "false")

if test "$selected_autoLogin" != "$autoLogin"
  set autoLogin $selected_autoLogin
  sed -i -e "s/autoLogin = .*/autoLogin = $autoLogin;/" ../nixos/env.nix
  echo "Updated autoLogin to $autoLogin in env.nix"
end

# Prompt to change TimeZone Configuration
set selected_timezone (prompt_with_fzf "Select TimeZone (current: $timeZone): " "Keep Current: $timeZone" "Europe/Berlin" "America/New_York" "Asia/Tokyo" "Australia/Sydney" "UTC")

if test "$selected_timezone" != "Keep Current: $timeZone"
  set timeZone $selected_timezone
  sed -i -e "s/timeZone = \".*\"/timeZone = \"$timeZone\"/" ../nixos/env.nix
  echo "Updated timeZone to $timeZone in env.nix"
end

# Prompt to change Locales Configuration
set selected_locales (prompt_with_fzf "Select Locales (current: $locales): " "Keep Current: $locales" "en_US.UTF-8" "de_DE.UTF-8" "fr_FR.UTF-8" "es_ES.UTF-8" "it_IT.UTF-8")

if test "$selected_locales" != "Keep Current: $locales"
  set locales $selected_locales
  sed -i -e "s/locales = \[ \".*\" \]/locales = \[ \"$locales\" \]/" ../nixos/env.nix
  echo "Updated locales to $locales in env.nix"
end

# Prompt to change Keyboard Layout Configuration
set selected_keyboard_layout (prompt_with_fzf "Select Keyboard Layout (current: $keyboardLayout): " "Keep Current: $keyboardLayout" "us" "uk" "fr" "es" "it" "jp" "ru" "zh" "kr" "br")

if test "$selected_keyboard_layout" != "Keep Current: $keyboardLayout"
  set keyboardLayout $selected_keyboard_layout
  sed -i -e "s/keyboardLayout = \".*\"/keyboardLayout = \"$keyboardLayout\"/" ../nixos/env.nix
  echo "Updated keyboardLayout to $keyboardLayout in env.nix"
end
