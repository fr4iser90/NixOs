#/etc/nixos/build/setup/custom.nix
{ config, pkgs, ... }:

let
  env = import ../../../env.nix;
  defaultBrowser = env.defaultBrowser;
in
{
  environment.systemPackages = with pkgs; [
    lsof               # Lists open files.
    python3
    docker
    postman
    git                # Version control system.
    wget               # Network downloader.
    tree               # Display directories as trees.
    godot_4
    godot_4-export-templates
    nodejs_22
    discord
    kitty
    vscode
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
    kitty              # GPU-accelerated terminal emulator.
    ethtool            # Utility for examining and tuning network interfaces.
    htop               # Interactive process viewer.
    firefox
    lutris
    wine
    winetricks
    wineWowPackages.full
    jellyfin-media-player
    owncloud-client    #
    qemu_kvm # QEMU mit KVM-Unterstützung
    libvirt # Libvirt zur Verwaltung von VMs
    virt-manager # GUI zur Verwaltung von VMs
    code-cursor
  ];


  programs.steam.enable = env.enableSteam;
  programs.firefox.enable = true;
  virtualisation.docker.enable = true;
}
