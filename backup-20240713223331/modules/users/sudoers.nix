# /etc/nixos/modules/sudoers.nix
{ config, pkgs, ... }:

{
  security.sudo = {
    enable = true;
    extraRules = [
      {
        users = [ "fr4iser" "botchi" ];
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
