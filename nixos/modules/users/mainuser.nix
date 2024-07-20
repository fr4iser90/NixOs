{ config, pkgs, ... }:

let
  env = import ../../env.nix;
in
{
  users.users."${env.mainUser}" = {
    isNormalUser = true;
    extraGroups = [ "tty" "networkmanager" "wheel" "docker" "video" "audio" "render" "input" ];
    home = "/home/${env.mainUser}";
    shell = pkgs.${env.defaultShell};
    hashedPasswordFile = "/etc/nixos/secrets/passwords/.hashedLoginPassword";
  };

  # Enable linger for the main user to allow user services to run after logout
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
