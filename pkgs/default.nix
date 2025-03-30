{
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib,
}: let
  numpy-1 = pkgs.python311Packages.numpy.overridePythonAttrs (oldAttrs: rec {
    version = "1.26.4";
    src = pkgs.fetchPypi {
      pname = "numpy";
      inherit version;
      sha256 = "0410j6jfz1yzm5s0v0yrc1j0q6ih4322357and7arr0jxnlsn0ia";
    };
  });

  customPython = pkgs.python311.override {
    packageOverrides = self: super: {
      numpy = numpy-1;
    };
  };
  customPythonPackages = customPython.pkgs;
in {
  inherit numpy-1 customPythonPackages;

  fish-rust = pkgs.callPackage ./fish-rust {};

  python-rembg = pkgs.callPackage ./python-rembg {
    inherit lib;
    fetchPypi = pkgs.fetchPypi;
    python311Packages = customPythonPackages;
    python-pymatting = pkgs.callPackage ./python-pymatting {
      inherit lib;
      fetchPypi = pkgs.fetchPypi;
      python311Packages = customPythonPackages;
    };
    python-opencv-headless = pkgs.callPackage ./python-opencv-headless {
      inherit lib;
      fetchPypi = pkgs.fetchPypi;
      cmake = pkgs.cmake;
      pkg-config = pkgs.pkg-config;
      stdenv = pkgs.stdenv;
      makeWrapper = pkgs.makeWrapper;
      python311Packages = customPythonPackages;
    };
  };

  python-ngx-lsp = pkgs.callPackage ./python-nginx-language-server {
    inherit lib;
    fetchFromGitHub = pkgs.fetchFromGitHub;
    python311Packages = customPythonPackages;
  };
}
