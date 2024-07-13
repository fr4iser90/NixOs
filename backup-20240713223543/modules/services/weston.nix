# /etc/nixos/modules/services/weston.nix
{ config, pkgs, ... }:

{
  environment.etc."weston.ini".text = ''
    [core]
    backend=headless-backend.so
    socket=headless-0

    [output]
    name=VIRTUAL-1
    mode=1920x1080
    transform=90

    [output]
    name=HEADLESS-1
    mode=1920x1080

    [keyboard]
    keymap_layout=de
    
    [shell]
    locking=false
  '';
}
