# /etc/nixos/modules/overlays/python311.nix
final: prev: {
  python = prev.python3_11;
}

