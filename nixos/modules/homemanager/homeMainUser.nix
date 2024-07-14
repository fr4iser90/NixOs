# /etc/nixos/config/home-mainuser.nix
{ pkgs, lib, user, ... }:

let
  env = import ../../env.nix;
  #shellInitModule = import ./shellInit/index.nix { inherit pkgs lib; defaultShell = env.defaultShell; };
in
{
  home.stateVersion = "24.05";
  home.username = user;
  home.homeDirectory = lib.mkForce "/home/${user}";
  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    function fish_prompt
      echo -n (prompt_pwd)
      echo -n ' > '
    end
  '';

  #imports = [ shellInitModule ];

  home.sessionVariables = {
    # Add session variables here
  };

  home.packages = with pkgs; [
    # Add user-specific packages here
  ];
}
