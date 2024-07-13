#/etc/nixos/build/setup/custom.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lsof               # Lists open files.
    git                # Version control system.
    wget               # Network downloader.
    tree               # Display directories as trees.
    bitwarden-desktop  # Desktop application for Bitwarden, a password manager.
    firefox            # Popular open-source web browser.
    discord            # Voice, video, and text communication application.
    thunderbird        # Email client with support for chat and newsgroups.
    vscode             # Visual Studio Code, a code editor.
    kate               # Advanced text editor.
    sublime-text       # Sophisticated text editor for code, markup, and prose.
    lutris             # Open gaming platform.
    wine               # Compatibility layer for running Windows applications.
    wineWowPackages.full    # Full set of 32-bit and 64-bit Wine packages.
    winetricks         # Utility for Wine to manage software installation.
    pavucontrol        # PulseAudio volume control.
    vlc                # Versatile media player.
    ffmpeg             # Complete, cross-platform solution to record, convert and stream audio and video.
    handbrake          # Open-source video transcoder.
    audacity           # Free, open source, cross-platform audio software.
    kdenlive           # Free and open-source video editor.
    gimp               # GNU Image Manipulation Program.
    # spotify          # Digital music service.
    # kodi             # Open-source home theater software.
    plex-media-server  # Media server for managing and streaming your digital media.
    fish               # Friendly interactive shell.
    alacritty          # GPU-accelerated terminal emulator.
    ethtool            # Utility for examining and tuning network interfaces.
    htop               # Interactive process viewer.
    neofetch           # System information tool.
    ranger             # Console file manager with VI key bindings.
  ];

  programs.steam.enable = true;
  programs.firefox.enable = true;
  programs.fish.enable = true;
  nixpkgs.config.allowUnfree = true;
}
