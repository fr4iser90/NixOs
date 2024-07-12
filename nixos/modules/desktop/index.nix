#/etc/nixos/modules/desktop/index.nix
{ config, lib, pkgs, ... }:

let
  env = import ../../env.nix;
 # displayServerConfig = if env.displayServer == "wayland" then import ./wayland.nix { inherit config pkgs; } else import ./x11.nix { inherit config pkgs; };
  gpuConfig = if env.gpu == "nvidia" then import ./gpu/nvidia.nix { inherit config pkgs; }
              else if env.gpu == "nvidiaIntelPrime" then import ./gpu/nvidiaIntelPrime.nix { inherit config pkgs; }
              else import ./gpu/amdgpu.nix { inherit config pkgs; };
in {
  imports = [ gpuConfig ]; #displayServerConfig

  # Enable automatic login if specified in env.nix
  services.displayManager.autoLogin.enable = env.autoLogin;
  services.displayManager.autoLogin.user = env.mainUser;
}




