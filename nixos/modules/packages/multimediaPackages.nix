#/etc/nixos/modules/packages/multimediaPackages.nix
{ pkgs, ...}:
with pkgs; [
  pavucontrol        # PulseAudio volume control.
  # libxkbcommon     # Keyboard description library.
  # freetype         # Font rendering library.
]
