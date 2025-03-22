{
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib,
}: let
   python-opencv-headless = pkgs.callPackage ./python-opencv-headless {
    inherit (pkgs) lib fetchurl;
    python310Packages = pkgs.python310.pkgs;
  };

  python-pymatting = pkgs.callPackage ./python-pymatting {
    inherit (pkgs) lib fetchPypi;
    python310Packages = pkgs.python310.pkgs;
  };

  python-rembg = pkgs.callPackage ./python-rembg {
    inherit (pkgs) lib fetchPypi;
    inherit python-pymatting python-opencv-headless;
    python310Packages = pkgs.python310.pkgs;
  };
in {
  fish-rust = pkgs.callPackage ./fish-rust {};
  python-pymatting = python-pymatting;
  python-opencv-headless = python-opencv-headless;
  python-rembg = python-rembg;

  vivid-icons = pkgs.callPackage ./vivid-icons {
    inherit (pkgs) lib stdenv fetchFromGitHub;
  };
}
