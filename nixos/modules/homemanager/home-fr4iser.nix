# /etc/nixos/config/home-mainuser.nix
{ pkgs, lib, user, ... }:

{
  home.stateVersion = "24.05";
  home.username = user;
  home.homeDirectory = lib.mkForce "/home/${user}";

#  programs.bash.enable = true;    
  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    function fish_prompt
      echo -n (prompt_pwd)
      echo -n ' > '
    end
  '';


  home.sessionVariables = {
  };

  home.packages = with pkgs; [
    # Weitere benutzerspezifische Pakete hier hinzufügen
  ];
}
