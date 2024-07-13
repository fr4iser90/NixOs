#/etc/nixos/modules/packages/communicationPackages.nix
{ pkgs, ... }:
with pkgs; [
  discord               # Voice, video, and text communication application.
#  slack                 # Collaboration and messaging app for teams.
#  skypeforlinux         # Skype client for Linux.
#  signal-desktop        # Signal Private Messenger desktop client.
#  telegram-desktop      # Telegram desktop client.
#  zoom-us               # Video conferencing software.
#  mattermost-desktop    # Desktop client for Mattermost, an open-source messaging platform.
#  hexchat               # IRC client.
#  weechat               # Terminal-based IRC client.
#  pidgin                # Universal chat client.
#  wire-desktop          # Wire secure messaging and collaboration.
  thunderbird           # Email client with support for chat and newsgroups.
#  element-desktop       # Matrix client for secure communication.
]
