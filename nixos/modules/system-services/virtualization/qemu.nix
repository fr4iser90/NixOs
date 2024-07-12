{ config, pkgs, ... }:

{
  virtualisation.qemu = {
    enable = true;
    package = pkgs.qemu_kvm;
  };
}
