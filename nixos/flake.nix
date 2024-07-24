#/etc/nixos/flake.nix
{
  description = "NixOS Configuration with Home Manager";

  inputs = {
    # Define inputs for nixpkgs and home-manager
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, ... }: let
    # Specify the target system architecture
    system = "x86_64-linux"; 

    # Import overlays
    #overlays = [
    #];

    # Importing nixpkgs with the specified overlays (  inherit system overlays;)
    pkgs = import nixpkgs { inherit system; };

    # Extracting the lib attribute from pkgs
    lib = pkgs.lib;

    # Import environment-specific configurations
    env = import ./env.nix;

    # Define a function to import the home manager user module
    #userModule = user: import ./modules/homemanager/home-${user}.nix { inherit pkgs lib; user = user; };
    userModule = user: { config, ... }: import ./modules/homemanager/home-${user}.nix { inherit pkgs lib config home-manager; user = user; };


  in {
    # Define NixOS configurations
    nixosConfigurations = {
      "${env.hostName}" = nixpkgs.lib.nixosSystem {
        # Specify the system architecture again
        system = "x86_64-linux";

        modules = [
          ./configuration.nix               # Main configuration file
          home-manager.nixosModules.home-manager # Home Manager integration
          {
            home-manager.useGlobalPkgs = true;  # Use global packages for Home Manager
            home-manager.useUserPackages = true; # Allow user packages for Home Manager
            home-manager.users = {
              # Define Home Manager configuration for the main user
              "${env.mainUser}" = userModule env.mainUser;
              "${env.guestUser}" = userModule env.guestUser;
            };
          }
        ];
      };
    };
  };
}
