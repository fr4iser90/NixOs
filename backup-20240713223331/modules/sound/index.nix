# /etc/nixos/sound/index.nix
{ config, pkgs, ... }:

let
  env = import ../../env.nix;
in
if env.audio == "pipewire"
then import ./pipewire.nix { inherit config pkgs; }
else import ./pulseaudio.nix { inherit config pkgs; }
