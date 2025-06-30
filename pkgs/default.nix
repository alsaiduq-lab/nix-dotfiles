{
  pkgs,
  lib,
  rpcs3_latest,
}: let
  rpcs3Pkgs = pkgs.callPackage ./rpcs3 {
    inherit lib rpcs3_latest;
  };
in {
  inherit (rpcs3Pkgs) pugixml SDL3 rpcs3_latest;
  fish-rust = pkgs.callPackage ./fish-rust {};
  clear-sans = pkgs.callPackage ./clear-sans {};
  binary-font = pkgs.callPackage ./binary-font {};
  minijinja-cli = pkgs.callPackage ./minijinja-cli {};
}
