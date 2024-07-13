#!/usr/bin/env fish

# Check if ../nixos/env.nix exists, if not copy defaultEnv.nix to ../nixos/env.nix
if not test -f ../nixos/env.nix
  if test -f ./defaultEnv.nix
    cp ./defaultEnv.nix ../nixos/env.nix
  else
    echo "defaultEnv.nix not found and ../nixos/env.nix does not exist."
    exit 1
  end
end

# Display current env.nix content
echo "Current content of ../nixos/env.nix:"
cat ../nixos/env.nix

# Prompt to use, edit or delete the current env.nix
echo "Do you want to (u)se, (e)dit, or (d)elete the current env.nix? (u/e/d):"
read -l action

switch $action
  case u
    echo "Using existing env.nix."
  case e
    echo "Editing env.nix. Please make your changes and save the file."
    $EDITOR ../nixos/env.nix
  case d
    echo "Deleting existing env.nix and using defaultEnv.nix."
    rm ../nixos/env.nix
    cp ./defaultEnv.nix ../nixos/env.nix
  case '*'
    echo "Invalid option. Exiting."
    exit 1
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

# Check if fzf is installed
if not type -q fzf
  echo "fzf is not installed. Please install fzf to use this script."
  exit 1
end

# Prompt to change Desktop Environment Configuration
set -l desktop_options "Keep Current: $desktop" "gnome" "plasma" "xfce"
set -l selected_desktop (printf "%s\n" $desktop_options | fzf --prompt "Select Desktop Environment (current: $desktop): " --height 40% --layout=reverse --border)

if test "$selected_desktop" != "Keep Current: $desktop"
  set desktop $selected_desktop
  sed -i -e "s/desktop = \".*\"/desktop = \"$desktop\"/" ../nixos/env.nix
  echo "Updated desktop to $desktop in env.nix"
end

# Prompt to change Display Manager Configuration
set -l dm_options "Keep Current: $displayManager" "sddm" "lightdm" "gdm"
set -l selected_dm (printf "%s\n" $dm_options | fzf --prompt "Select Display Manager (current: $displayManager): " --height 40% --layout=reverse --border)

if test "$selected_dm" != "Keep Current: $displayManager"
  set displayManager $selected_dm
  sed -i -e "s/displayManager = \".*\"/displayManager = \"$displayManager\"/" ../nixos/env.nix
  echo "Updated displayManager to $displayManager in env.nix"
end

# Prompt to change Session Configuration
set -l session_options "Keep Current: $session" "plasma" "plasmawayland"
set -l selected_session (printf "%s\n" $session_options | fzf --prompt "Select Session (current: $session): " --height 40% --layout=reverse --border)

if test "$selected_session" != "Keep Current: $session"
  set session $selected_session
  sed -i -e "s/session = \".*\"/session = \"$session\"/" ../nixos/env.nix
  echo "Updated session to $session in env.nix"
end

# Prompt to change Auto Login Configuration
set -l autoLogin_options "true" "false"
set -l selected_autoLogin (printf "%s\n" $autoLogin_options | fzf --prompt "Select Auto Login (current: $autoLogin): " --height 40% --layout=reverse --border)

if test "$selected_autoLogin" != "$autoLogin"
  set autoLogin $selected_autoLogin
  sed -i -e "s/autoLogin = .*/autoLogin = $autoLogin;/" ../nixos/env.nix
  echo "Updated autoLogin to $autoLogin in env.nix"
end

# Prompt to change TimeZone Configuration
set -l timezone_options "Keep Current: $timeZone" "Europe/Berlin" "America/New_York" "Asia/Tokyo" "Australia/Sydney" "UTC"
set -l selected_timezone (printf "%s\n" $timezone_options | fzf --prompt "Select TimeZone (current: $timeZone): " --height 40% --layout=reverse --border)

if test "$selected_timezone" != "Keep Current: $timeZone"
  set timeZone $selected_timezone
  sed -i -e "s/timeZone = \".*\"/timeZone = \"$timeZone\"/" ../nixos/env.nix
  echo "Updated timeZone to $timeZone in env.nix"
end

# Prompt to change Locales Configuration
set -l locales_options "Keep Current: $locales" "en_US.UTF-8" "de_DE.UTF-8" "fr_FR.UTF-8" "es_ES.UTF-8" "it_IT.UTF-8"
set -l selected_locales (printf "%s\n" $locales_options | fzf --prompt "Select Locales (current: $locales): " --height 40% --layout=reverse --border)

if test "$selected_locales" != "Keep Current: $locales"
  set locales $selected_locales
  sed -i -e "s/locales = \[ \".*\" \]/locales = \[ \"$locales\" \]/" ../nixos/env.nix
  echo "Updated locales to $locales in env.nix"
end

# Prompt to change Keyboard Layout Configuration
set -l keyboard_layout_options "Keep Current: $keyboardLayout" "us" "uk" "fr" "es" "it" "jp" "ru" "zh" "kr" "br"
set -l selected_keyboard_layout (printf "%s\n" $keyboard_layout_options | fzf --prompt "Select Keyboard Layout (current: $keyboardLayout): " --height 40% --layout=reverse --border)

if test "$selected_keyboard_layout" != "Keep Current: $keyboardLayout"
  set keyboardLayout $selected_keyboard_layout
  sed -i -e "s/keyboardLayout = \".*\"/keyboardLayout = \"$keyboardLayout\"/" ../nixos/env.nix
  echo "Updated keyboardLayout to $keyboardLayout in env.nix"
end
