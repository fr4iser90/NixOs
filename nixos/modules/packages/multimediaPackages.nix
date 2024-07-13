#/etc/nixos/modules/packages/multimediaPackages.nix
{ pkgs, ... }:
with pkgs; [
  pavucontrol        # PulseAudio volume control.
  vlc                # Versatile media player.
#  mpv                # Media player based on MPlayer and mplayer2.
  ffmpeg             # Complete, cross-platform solution to record, convert and stream audio and video.
  handbrake          # Open-source video transcoder.
  audacity           # Free, open source, cross-platform audio software.
  kdenlive           # Free and open-source video editor.
#  blender            # Open-source 3D creation suite.
  gimp               # GNU Image Manipulation Program.
#  inkscape           # Open-source vector graphics editor.
#  obs-studio         # Software for live streaming and screen recording.
#  cheese             # Webcam application for recording and taking photos.
#  shotwell           # Photo manager for GNOME.
#  darktable          # Open-source photography workflow application and raw developer.
#  rawtherapee        # Cross-platform raw image processing program.
#  rhythmbox          # Music playing application for GNOME.
#  clementine         # Modern music player and library organizer.
#  spotify            # Digital music service.
#  kodi               # Open-source home theater software.
  plex-media-server  # Media server for managing and streaming your digital media.
#  mediainfo          # Tool for displaying technical information about media files.
#  sox                # Command-line utility that can convert various formats of computer audio files.
#  flac               # Free Lossless Audio Codec.
#  opus-tools         # Utilities to encode, inspect, and decode .opus files.
#  soundconverter     # GNOME application to convert audio files.
#  simplescreenrecorder # Screen recorder for Linux.
#  vokoscreenNG       # Easy to use screencast creator.
#  picard             # MusicBrainz Picard, a cross-platform music tagger.
#  gnome-sound-recorder # Simple sound recorder for GNOME.
#  brasero            # CD/DVD mastering tool for GNOME.
#  mkvtoolnix         # Set of tools to create, alter, and inspect Matroska files.
]