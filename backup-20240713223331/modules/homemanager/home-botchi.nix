# /etc/nixos/config/home-botchi.nix
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
    WAYLAND_DISPLAY = "headless-0";
    XDG_SESSION_TYPE = "wayland";
    XDG_RUNTIME_DIR = "/run/user/1001";
    PATH = "/run/current-system/sw/bin:${pkgs.inetutils}/bin:${pkgs.util-linux}/bin";
  };
}
