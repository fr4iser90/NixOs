#/etc/nixos/flake.nix
{
  description = "NixOS Configuration with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    lib = pkgs.lib;
    env = import ./env.nix;
    userModule = user: import ./modules/homemanager/home-${user}.nix { inherit pkgs lib; user = user; };
  in {
    nixosConfigurations = {
      "${env.hostName}" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users = lib.recursiveUpdate 
              (if env.mainUser != null && env.mainUser != "" then {
                "${env.mainUser}" = userModule env.mainUser;
              } else {})
              (if env.guestUser != null && env.guestUser != "" then {
                "${env.guestUser}" = userModule env.guestUser;
              } else {});
          }
        ];
      };
    };

    homeConfigurations = lib.recursiveUpdate
      (if env.mainUser != null && env.mainUser != "" then {
        "${env.mainUser}" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [ userModule env.mainUser ];
        };
      } else {})
      (if env.guestUser != null && env.guestUser != "" then {
        "${env.guestUser}" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [ userModule env.guestUser ];
        };
      } else {});
  };
}
