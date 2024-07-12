{ config, pkgs, ... }:

let
  env = import ../../env.nix;
in
{
  security.sudo = {
    enable = true;
    extraRules = [
      {
        users = [ env.mainUser "fr4iser" ];
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
