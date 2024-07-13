{ config, pkgs, ... }:

{
  imports = [
    ./mainuser.nix
    ./guestuser.nix
    ./sudoers.nix
  ];
}
