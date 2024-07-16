#!/usr/bin/env fish

# Ensure fzf is installed
if not command -v fzf > /dev/null
  echo "fzf is not installed. Please install it using your package manager."
  exit 1
end

# Path to the package list file
set package_list ./packageList.conf

# Check if the package list file exists
if not test -f $package_list
  echo "Package list file $package_list does not exist."
  exit 1
end

# Generate fzf options
set -l fzf_options

# Read the package list file and generate fzf options
for line in (cat $package_list)
  if test -n "$line"
    set group (echo $line | cut -d':' -f1)
    set packages (echo $line | cut -d':' -f2- | tr ' ' '\n')

    for package in $packages
      if test -n "$package"
        set fzf_options $fzf_options "$package ($group package)"
      end
    end
  end
end

# Display the checklist using fzf with multi-select enabled
set -l selected_packages (printf "%s\n" $fzf_options | fzf --multi --prompt "Select packages to install (use TAB to select, ENTER to confirm): " --header "Press TAB to select multiple options" --height 40% --layout=reverse --border)

# Check if the user canceled the selection
if test -z "$selected_packages"
  echo "No packages selected or selection was canceled."
  exit 1
end

# Print selected packages
echo "Selected packages: $selected_packages"

# Save selected packages to a file
echo '{ pkgs, ... }:' > ../nixos/modules/packages/userPackages.nix
echo "with pkgs; [" >> ../nixos/modules/packages/userPackages.nix
echo $selected_packages | sed 's/([^)]*)//g' | tr '\n' ' ' | tr -s ' ' >> ../nixos/modules/packages/userPackages.nix
echo "]" >> ../nixos/modules/packages/userPackages.nix

echo "Output has been saved to ../nixos/modules/packages/userPackages.nix"
