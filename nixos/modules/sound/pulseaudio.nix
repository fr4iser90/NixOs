{ config, pkgs, ... }:

{
  hardware.pulseaudio.enable = true; # Ensure PulseAudio is enabled
  security.rtkit.enable = true;
}
