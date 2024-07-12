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
    (if env.virtualization.docker then [ ./virtualization/docker.nix ] else [])
    (if env.virtualization.podman then [ ./virtualization/podman.nix ] else [])
    (if env.virtualization.kvm then [ ./virtualization/kvm.nix ] else [])
    (if env.virtualization.qemu then [ ./virtualization/qemu.nix ] else [])
    (if env.virtualization.virtualbox then [ ./virtualization/virtualbox.nix ] else [])
    (if env.virtualization.lxc then [ ./virtualization/lxc.nix ] else [])
    (if env.virtualization.firecracker then [ ./virtualization/firecracker.nix ] else [])
 #   (if env.enablePrinting then [ ./utility/cups.nix ] else [])
  ];
}
