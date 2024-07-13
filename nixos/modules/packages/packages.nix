{ config, pkgs, ... }:

let
  # Funktion, um Pakete basierend auf dem Setup auszuwählen
  setupPackages = setup: import ./modules/packages/setups/${setup}.nix { inherit pkgs; };
  customPackages = import ./modules/packages/customPackages.nix { inherit pkgs; };
  
  # Lade die env.nix Datei, um das Setup zu bestimmen
  env = import ../nixos/env.nix;

  # Bestimme die Pakete basierend auf dem Setup
  selectedPackages = setupPackages env.setup;

  allPackages = pkgs.lib.concatLists [
    selectedPackages
    customPackages
  ];
in
{
  environment.systemPackages = allPackages;
  # Enable Docker virtualisation
  virtualisation.docker.enable = true;

  programs.steam.enable = true;
  # Install firefox.
  programs.firefox.enable = true;
  programs.fish.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable experimental features for nix
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
