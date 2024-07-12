# /etc/nixos/config/configuration.nix
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix # Don't touch!
      ./modules/bootloader/bootloader.nix
      ./modules/networking/networking.nix
      ./modules/users/index.nix
      ./modules/desktop/index.nix
      ./modules/sound/index.nix
#      ./modules/system-services/utility/garbagecollector.nix
      ./modules/packages/packages.nix
      ./modules/system-services/system-services.nix
#      ./modules/system-services/remote/sunshine.nix
    ];
  system.stateVersion = "24.05"; 
}
