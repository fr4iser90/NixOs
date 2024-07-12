# /etc/nixos/modules/overlays/miniupnpc.nix
self: super: {
  miniupnpc = super.miniupnpc.overrideAttrs (oldAttrs: {
    version = "2.2.7";
    src = super.fetchurl {
      url = "https://github.com/miniupnp/miniupnp/archive/refs/tags/miniupnpc_2_2_7.tar.gz";
      sha256 = "506Wg6Zpk3CruqQaJlKGwKhJiXJHJ739AOlFAhEWQmc=";
    };
  });
}
