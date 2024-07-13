# /etc/nixos/modules/system-services.nix
{ config, pkgs, lib, ... }:

let
  env = import ../../env.nix;
in
{
  # Enable D-Bus
  services.dbus.enable = true;
  services.udev.packages = [ pkgs.libinput ];
#  virtualisation.docker.enable = true;
#  virtualisation.docker.package = pkgs.docker;

  # Conditionally import service configurations based on env settings
  imports = lib.flatten [
    (if env.enableSSH then [ ./remote/sshd.nix ] else [])
    (if env.enableRemoteDesktop then [ ./remote/sunshine.nix ] else [])
  ];
}
