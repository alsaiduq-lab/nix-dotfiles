{
  pkgs,
  lib,
  rpcs3_latest,
  customFontPkgs,
}: let
  rpcs3Pkgs = pkgs.callPackage ./rpcs3 {
    inherit lib rpcs3_latest;
  };
in {
  inherit (rpcs3Pkgs) pugixml SDL3 rpcs3 rpcs3_latest;
  fish-rust = pkgs.callPackage ./fish-rust {};
  inherit (customFontPkgs) clear-sans binary-font;
}
