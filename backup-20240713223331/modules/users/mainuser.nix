# /etc/nixos/modules/users/mainuser.nix
{ config, pkgs, ... }:

let
  env = import ../../env.nix;
in
{
  users.users."${env.mainUser}" = {
    isNormalUser = true;
    extraGroups = [ "tty" "networkmanager" "wheel" "docker" "video" "audio" "render" "input" ];
    shell = pkgs.fish;
  };

  # Enable automatic login for the main user
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = env.mainUser;

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  # Enable linger for the main user to allow user services to run after logout
}
