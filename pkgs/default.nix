{ pkgs ? import <nixpkgs> {}, lib ? pkgs.lib }:

{
  fish-rust = pkgs.callPackage ./fish-rust {};
  python-rembg = pkgs.callPackage ./python-rembg {
    inherit (pkgs) lib fetchPypi;
    python310Packages = pkgs.python310.pkgs;
  };
}
