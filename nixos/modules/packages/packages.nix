{ config, pkgs, ... }:

let
  commonPackages = import ./modules/packages/commonPackages.nix { inherit pkgs; };
  developmentPackages = import ./modules/packages/developmentPackages.nix { inherit pkgs; };
  communicationPackages = import ./modules/packages/communicationPackages.nix { inherit pkgs; };
  shellsAndTerminals = import ./modules/packages/shellsAndTerminals.nix { inherit pkgs; };
  gamingPackages = import ./modules/packages/gamingPackages.nix { inherit pkgs; };
  multimediaPackages = import ./modules/packages/multimediaPackages.nix { inherit pkgs; };
  systemUtilities = import ./modules/packages/systemUtilities.nix { inherit pkgs; };

  allPackages = pkgs.lib.concatLists [
    commonPackages
    developmentPackages
    communicationPackages
    shellsAndTerminals
    gamingPackages
    multimediaPackages
    systemUtilities
  ];
in
{
  environment.systemPackages = with pkgs; allPackages;
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
