{
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib,
}: {
  fish-rust = pkgs.callPackage ./fish-rust {};
  python-pymatting = pkgs.callPackage ./python-pymatting {
    inherit lib;
    fetchPypi = pkgs.fetchPypi;
    python311Packages = pkgs.python311Packages;
  };
  python-opencv-headless = pkgs.callPackage ./python-opencv-headless {
    inherit lib;
    fetchPypi = pkgs.fetchPypi;
    cmake = pkgs.cmake;
    pkg-config = pkgs.pkg-config;
    stdenv = pkgs.stdenv;
    makeWrapper = pkgs.makeWrapper;
    python311Packages = pkgs.python311Packages;
  };
  python-rembg = pkgs.callPackage ./python-rembg {
    inherit lib;
    fetchPypi = pkgs.fetchPypi;
    python-pymatting = pkgs.callPackage ./python-pymatting {
      inherit lib;
      fetchPypi = pkgs.fetchPypi;
      python311Packages = pkgs.python311Packages;
    };
    python-opencv-headless = pkgs.callPackage ./python-opencv-headless {
      inherit lib;
      fetchPypi = pkgs.fetchPypi;
      cmake = pkgs.cmake;
      pkg-config = pkgs.pkg-config;
      stdenv = pkgs.stdenv;
      makeWrapper = pkgs.makeWrapper;
      python311Packages = pkgs.python311Packages;
    };
    python311Packages = pkgs.python311Packages;
  };
  vivid-icons = pkgs.callPackage ./vivid-icons {
    inherit lib;
    stdenv = pkgs.stdenv;
    fetchFromGitHub = pkgs.fetchFromGitHub;
  };
}
