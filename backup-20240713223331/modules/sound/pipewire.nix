# /etc/nixos/modules/sound/sound.nix

{ config, pkgs, ... }:

{
  hardware.pulseaudio.enable = false; # Stelle sicher, dass PulseAudio aktiviert ist
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;

    configPackages = [
      (pkgs.writeTextFile {
        name = "custom-pipewire-config";
        destination = "/etc/pipewire/pipewire.conf";
        text = ''
          context.modules = [
            { name = libpipewire-module-rtkit }
            { name = libpipewire-module-alsa-source args = { device = "hw:2,0" } }
            { name = libpipewire-module-alsa-source args = { device = "hw:3,0" } }
          ];
          default.clock.allowed-rates = [ 48000 44100 ];
          default.clock.rate = 48000;
          default.clock.quantum = 1024;
          default.clock.min-quantum = 32;
          default.clock.max-quantum = 8192;
        '';
      })
    ];
  };

  # Erstelle die PulseAudio-Konfigurationsdatei
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
