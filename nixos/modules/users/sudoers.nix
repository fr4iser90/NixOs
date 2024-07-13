{ config, pkgs, ... }:

let
  env = import ../../env.nix;
in
{
  security.sudo = {
    enable = true;
    extraRules = [
      {
        users = [ env.mainUser ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
