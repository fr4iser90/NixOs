#/etc/nixos/modules/packages/shellAndTerminals.nix
{ pkgs, ... }:
with pkgs; [
  fish                # Friendly interactive shell.
  alacritty           # GPU-accelerated terminal emulator.
#  kitty               # Fast, feature-rich, GPU-based terminal emulator.
#  zsh                 # Highly customizable interactive shell.
#  bash                # GNU Bourne Again Shell.
#  tmux                # Terminal multiplexer.
#  screen              # Terminal multiplexer.
#  terminator          # Terminal emulator with multiple terminals in one window.
#  tilix               # Tiling terminal emulator for GNOME.
#  xfce4-terminal      # Terminal emulator for the Xfce desktop environment.
#  gnome-terminal      # Terminal emulator for the GNOME desktop environment.
  konsole             # Terminal emulator for the KDE desktop environment.
#  rxvt-unicode        # Highly customizable terminal emulator.
#  guake               # Drop-down terminal for GNOME.
#  yakuake             # Drop-down terminal for KDE.
]
