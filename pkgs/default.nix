{ pkgs ? import <nixpkgs> {}, lib ? pkgs.lib }:

let
  python-pymatting = pkgs.callPackage ./python-pymatting {
    inherit (pkgs) lib fetchPypi;
    python310Packages = pkgs.python310.pkgs;
  };
in
{
  fish-rust = pkgs.callPackage ./fish-rust {};
  python-pymatting = python-pymatting;
  python-rembg = pkgs.callPackage ./python-rembg {
    inherit (pkgs) lib fetchPypi;
    python310Packages = pkgs.python310.pkgs;
    inherit python-pymatting;
  };
}
