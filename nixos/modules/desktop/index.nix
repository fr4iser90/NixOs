#/etc/nixos/modules/desktop/index.nix
{ config, lib, pkgs, ... }:

let
  env = import ../../env.nix;
  gpuConfig = if env.gpu == "nvidia" then import ./gpu/nvidia.nix { inherit config pkgs; }
              else if env.gpu == "nvidiaIntelPrime" then import ./gpu/nvidiaIntelPrime.nix { inherit config pkgs; }
              else import ./gpu/amdgpu.nix { inherit config pkgs; };
in {
  imports = [ 
    gpuConfig 
    ./x11.nix
    ./wayland.nix
    ./displayManager.nix
    ./desktopManager.nix
  ];
}




