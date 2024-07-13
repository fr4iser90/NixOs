# /etc/nixos/config/configuration.nix
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix # Don't touch!
      ./modules/networking/networking.nix
      ./modules/users/index.nix
      ./modules/desktop/index.nix
      ./modules/sound/index.nix
      ./modules/garbagecollector/garbagecollector.nix
      ./modules/packages/packages.nix
      ./modules/system-services/system-services.nix
      ./modules/bootloader/bootloader.nix
      ./modules/services/sshd.nix
#     ./modules/programs/amd-gpu-sunshine.nix
#     ./modules/programs/botchi-sunshine.nix
#     ./modules/programs/nvidia-gpu-sunshine.nix
#     ./modules/services/x-server-guest.nix
    ];

  system.stateVersion = "24.05"; 
}
