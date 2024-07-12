{ config, pkgs, ... }:

let
  env = import ../../env.nix;
in
{
  users.users."${env.guestUser}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" "render" "tty" "users" "dbus" "systemd-journal" ];
    shell = pkgs.fish;
  };

  systemd.services."getty@tty3".enable = false;
  systemd.services."autovt@tty3".enable = false;
}
