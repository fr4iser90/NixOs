{ config, pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.enable = true;
}
