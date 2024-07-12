#/etc/nixos/modules/packages/shellAndTerminals.nix
{ pkgs, ...}:
with pkgs; [
  fish               # Friendly interactive shell.
  alacritty          # GPU-accelerated terminal emulator.
  # kitty            # Another terminal emulator.
]

