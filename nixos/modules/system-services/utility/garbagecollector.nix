# /etc/nixos/modules/garbagecollector.nix

{
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 30d";
  };
}
