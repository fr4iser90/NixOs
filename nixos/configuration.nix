# /etc/nixos/config/configuration.nix
{ config, pkgs, ... }:

let
  env = import ./env.nix;
  desktopModules = if env.setup == "server" then [] else [
    ./modules/desktop/index.nix
    ./modules/sound/index.nix
  ];
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix # Don't touch!
      ./modules/bootloader/bootloader.nix
      ./modules/desktop/index.nix
      ./modules/networking/networking.nix
      ./modules/users/index.nix
#      ./modules/system-services/utility/garbagecollector.nix
      ./modules/packages/packages.nix
      ./modules/system-services/system-services.nix
    ];

  #console.keyMap = env.keyboardLayout;
  system.stateVersion = "24.05"; 
}
