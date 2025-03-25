{ pkgs ? import <nixpkgs> {}, lib ? pkgs.lib }:

let
  numpy-1 = pkgs.python311Packages.numpy.overridePythonAttrs (oldAttrs: rec {
    version = "1.26.4";
    src = pkgs.fetchPypi {
      pname = "numpy";
      inherit version;
      sha256 = "0410j6jfz1yzm5s0v0yrc1j0q6ih4322357and7arr0jxnlsn0ia";
    };
    meta.priority = -1;
  });

  customPackages = pkgs.python311Packages.override {
    overrides = self: super: {
      numpy = numpy-1;
    };
  };

in {

  fish-rust = pkgs.callPackage ./fish-rust {};

  python-pymatting = pkgs.callPackage ./python-pymatting {
    inherit lib;
    fetchPypi = pkgs.fetchPypi;
    python311Packages = customPackages;
  };

  python-opencv-headless = pkgs.callPackage ./python-opencv-headless {
    inherit lib;
    fetchPypi = pkgs.fetchPypi;
    cmake = pkgs.cmake;
    pkg-config = pkgs.pkg-config;
    stdenv = pkgs.stdenv;
    makeWrapper = pkgs.makeWrapper;
    python311Packages = customPackages;
  };

  python-rembg = pkgs.callPackage ./python-rembg {
    inherit lib;
    fetchPypi = pkgs.fetchPypi;
    python311Packages = customPackages;

    python-pymatting = pkgs.callPackage ./python-pymatting {
      inherit lib;
      fetchPypi = pkgs.fetchPypi;
      python311Packages = customPackages;
    };

    python-opencv-headless = pkgs.callPackage ./python-opencv-headless {
      inherit lib;
      fetchPypi = pkgs.fetchPypi;
      cmake = pkgs.cmake;
      pkg-config = pkgs.pkg-config;
      stdenv = pkgs.stdenv;
      makeWrapper = pkgs.makeWrapper;
      python311Packages = customPackages;
    };
  };

  pythonPackages = customPackages;
  vivid-icons = pkgs.callPackage ./vivid-icons {
    inherit lib;
    stdenv = pkgs.stdenv;
    fetchFromGitHub = pkgs.fetchFromGitHub;
  };
}
