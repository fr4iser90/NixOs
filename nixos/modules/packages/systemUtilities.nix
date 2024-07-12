#/etc/nixos/modules/packages/systemUtilities.nix
{ pkgs, ...}:
with pkgs; [
  # samba            # SMB/CIFS file, print, and login server.
  # sambaFull        # Full version of Samba.
  lshw               # Hardware lister.
  # libnotify        # Desktop notification library.
  # yad              # Yet another dialog, a user dialog tool.
  # nss              # Network Security Services libraries.
  # liburing         # Library for Linux native I/O.
  ethtool            # Utility for examining and tuning network interfaces.
]
