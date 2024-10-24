# config/weston.nix
{ config, pkgs, ... }:

{
  services.weston = {
    enable = true;
    user = "botchi";
    display = ":99";
    virtualDisplay = true;
    config = ''
      [core]
      backend=headless-backend.so
      idle-time=0

      [output]
      name=headless
      mode=1920x1080@60
    '';
  };
}
