{ config, pkgs, ... }:


let
  # Load the env.nix file to determine the setup
  env = import ../../env.nix;

  # Function to select packages based on the setup
  setupPackages = 
    if env.setup == "gaming" then import ./setups/gaming.nix 
    else if env.setup == "multimedia" then import ./setups/multimedia.nix 
    else if env.setup == "server" then import ./setups/server.nix 
    else if env.setup == "serverRemoteDesktop" then import ./setups/serverRemoteDesktop.nix
    else if env.setup == "workspace" then import ./setups/workspace.nix 
    else if env.setup == "custom" then import ./setups/custom.nix 
    else {}; # Default to an empty set if setup is not recognized
in
{
  imports = [
    ./customPackages.nix            # import custom packages
    ./appimage.nix                  # run .appImage files
    ./modules/shells.nix            # import shell 
    setupPackages                   # import setupPackages if set
  ];
  
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Enable experimental features for nix
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
