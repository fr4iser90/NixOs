# /etc/nixos/modules/overlays/sunshine.nix
final: prev: {
  sunshine = prev.sunshine.overrideAttrs (oldAttrs: rec {
    version = "2024.710.151651";
    src = prev.fetchFromGitHub {
      owner = "LizardByte";
      repo = "Sunshine";
      rev = "v${version}";
      sha256 = "6FHJidnXl8pKqpaboBnqlbI2fNcCWlumnNpDCWay9BM=";
    };
    buildInputs = (oldAttrs.buildInputs or []) ++ [
      final.cmake
      final.libpng
      final.libjpeg
      final.libtiff
      final.zlib
    ];
  });
}
