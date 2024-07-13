{ config, pkgs, ... }:

{
  hardware.pulseaudio.enable = true; # Ensure PulseAudio is enabled
  security.rtkit.enable = true;

  # Create the PulseAudio configuration file
  environment.etc."pulse/default.pa".text = ''
    # Unload all existing sources
    .ifexists module-udev-detect.so
    unload-module module-udev-detect
    .endif

    # Load only the specified sources
    load-module module-alsa-source device=hw:2,0
    load-module module-alsa-source device=hw:3,0

    # Optionally, set the default source
    set-default-source alsa_input.usb-Torch_Streaming_Microphone
  '';
}
