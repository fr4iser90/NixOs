# /etc/nixos/modules/sound/pulseaudio.nix

{ config, pkgs, ... }:

{
  hardware.pulseaudio.enable = true; # Stelle sicher, dass PulseAudio aktiviert ist
  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    pulseaudio
    pavucontrol    # PulseAudio Volume Control
    alsa-utils     # ALSA Utilities
    qpwgraph       # Graphisches Frontend für PulseAudio/PipeWire
    mda_lv2        # LADSPA-Plugins
    calf           # Weitere Audio-Plugins
    noisetorch     # Noisecanceling
  ];

  # PulseAudio Konfiguration
  hardware.pulseaudio = {
    package = pkgs.pulseaudioFull; # Verwende das vollständige PulseAudio-Paket mit allen Plugins
    support32Bit = true; # Falls du 32-Bit-Unterstützung benötigst
  };
}
