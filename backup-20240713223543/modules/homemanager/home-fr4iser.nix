# /etc/nixos/config/home-fr4iser.nix
{ pkgs, lib, user, ... }:

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

  home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_RUNTIME_DIR = "/run/user/1000";
  };

  home.packages = with pkgs; [
    # Weitere benutzerspezifische Pakete hier hinzufügen
  ];
}
