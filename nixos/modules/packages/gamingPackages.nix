#/etc/nixos/modules/packages/gamingPackages.nix
{ pkgs, ...}:
with pkgs; [
  lutris                  # Open gaming platform.
  wine                    # Compatibility layer for running Windows applications.
  wineWowPackages.full    # Full set of 32-bit and 64-bit Wine packages.
  winetricks              # Utility for Wine to manage software installation.
]
