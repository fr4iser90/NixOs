{ config, pkgs, ... }:
let
  env = import ../../env.nix;
  guestuser = env.guestUser;
in
{
  imports = [
    ./mainuser.nix
    ./sudoers.nix
  ] ++ (if guestuser != "" then [ ./guestuser.nix ] else []);
}
