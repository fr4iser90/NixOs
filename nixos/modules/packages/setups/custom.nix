#/etc/nixos/build/setup/custom.nix
{ config, pkgs, ... }:

let
  env = import ../../../env.nix;
  defaultBrowser = env.defaultBrowser;
in
{
  environment.systemPackages = with pkgs; [
    lsof               # Lists open files.
    git                # Version control system.
    wget               # Network downloader.
    tree               # Display directories as trees.
    #bitwarden-desktop  # Desktop application for Bitwarden, a password manager.
    bitwarden-cli
    discord            # Voice, video, and text communication application.
    thunderbird        # Email client with support for chat and newsgroups.
    kate               # Advanced text editor.
    pavucontrol        # PulseAudio volume control.
    vlc                # Versatile media player.
    ffmpeg             # Complete, cross-platform solution to record, convert and stream audio and video.
    audacity           # Free, open source, cross-platform audio software.
    gimp               # GNU Image Manipulation Program.
    # spotify          # Digital music service.
    # kodi             # Open-source home theater software.
    fish               # Friendly interactive shell.
    alacritty          # GPU-accelerated terminal emulator.
    ethtool            # Utility for examining and tuning network interfaces.
    htop               # Interactive process viewer.
    wireguard-tools    # WireGuard command line tools.
    plex               # Plex Media Server.
    brave              # Browser
    owncloud-client    #
  ];
  services.wg-netmanager.enable = true;
  programs.steam.enable = env.enableSteam;
  
}
