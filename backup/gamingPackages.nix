#/etc/nixos/modules/packages/gamingPackages.nix
{ pkgs, ... }:
with pkgs; [
  lutris                  # Open gaming platform.
  wine                    # Compatibility layer for running Windows applications.
  wineWowPackages.full    # Full set of 32-bit and 64-bit Wine packages.
  winetricks              # Utility for Wine to manage software installation.
#  steam                   # Steam gaming platform.  use steamenable instead
#  playonlinux             # Frontend for Wine.
#  dosbox                  # x86 emulator with DOS.
#  scummvm                 # Emulator for classic adventure games.
#  retroarch               # Frontend for emulators, game engines, and media players.
#  mame                    # Multiple Arcade Machine Emulator.
#  pcsx2                   # PlayStation 2 emulator.
#  dolphin                 # GameCube and Wii emulator.
#  yuzu                    # Nintendo Switch emulator.
#  rpcs3                   # PlayStation 3 emulator.
#  ppsspp                  # PSP emulator.
#  mednafen                # Multi-system emulator.
#  openmsx                 # MSX emulator.
#  visualboyadvance-m      # Game Boy Advance emulator.
#  nestopia                # NES/Famicom emulator.
#  mgba                    # Game Boy Advance emulator.
#  libretro                # Collection of emulators and game engines.
#  itch-setup              # Client for itch.io, an open marketplace for indie games.
]
