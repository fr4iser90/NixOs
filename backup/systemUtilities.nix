#/etc/nixos/modules/packages/systemUtilities.nix
{ pkgs, ...}:
with pkgs; [
  # samba            # SMB/CIFS file, print, and login server.
  # sambaFull        # Full version of Samba.
  # libnotify        # Desktop notification library.
  # yad              # Yet another dialog, a user dialog tool.
  # nss              # Network Security Services libraries.
  # liburing         # Library for Linux native I/O.
  lshw               # Hardware lister.
  ethtool            # Utility for examining and tuning network interfaces.
  htop               # Interactive process viewer.
  neofetch           # System information tool.
  ranger             # Console file manager with VI key bindings.
#  mc                 # Midnight Commander, a visual file manager.
#  lf                 # Terminal file manager written in Go.
  fd                 # Simple, fast, and user-friendly alternative to `find`.
  bat                # Cat clone with syntax highlighting and Git integration.
#  fzf                # Command-line fuzzy finder.
#  ripgrep            # Line-oriented search tool.
  exa                # Modern replacement for `ls`.
#  duf                # Disk usage utility with a user-friendly interface.
#  ncdu               # Disk usage analyzer with an ncurses interface.
]
