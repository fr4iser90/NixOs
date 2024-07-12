#/etc/nixos/modules/packages/commonPackages.nix
{ pkgs, ...}:
with pkgs; [
  lsof               # Lists open files.
  git                # Version control system.
  wget               # Network downloader.
  tree               # Display directories as trees.
  bitwarden-desktop  # Desktop application for Bitwarden, a password manager.
  # corefonts        # Microsoft TrueType core fonts.
]
