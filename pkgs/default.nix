{
  pkgs,
  lib,
}: {
  clear-sans = pkgs.callPackage ./clear-sans {};
  binary-font = pkgs.callPackage ./binary-font {};
  minijinja-cli = pkgs.callPackage ./minijinja-cli {};
  thorium = pkgs.callPackage ./thorium {};
}
