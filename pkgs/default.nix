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

  customPydantic = pkgs.python311Packages.override {
    overrides = self: super: {
      numpy = numpy-1;
      pydantic = super.pydantic.overridePythonAttrs (oldAttrs: rec {
        version = "1.10.18";
        src = pkgs.fetchPypi {
          pname = "pydantic";
          inherit version;
          sha256 = "uuvf8ZB9HZahOcJRNqm7fRfhGPEzp2ou87hF6DHjQDo=";
        };
        nativeBuildInputs = oldAttrs.nativeBuildInputs or [] ++ [ self.setuptools ];
      });
    };
  };
in {
  fish-rust = pkgs.callPackage ./fish-rust {};

  python-rembg = pkgs.callPackage ./python-rembg {
    inherit lib;
    fetchPypi = pkgs.fetchPypi;
    python311Packages = numpy-1;

    python-pymatting = pkgs.callPackage ./python-pymatting {
      inherit lib;
      fetchPypi = pkgs.fetchPypi;
      python311Packages = numpy-1;
    };

    python-opencv-headless = pkgs.callPackage ./python-opencv-headless {
      inherit lib;
      fetchPypi = pkgs.fetchPypi;
      cmake = pkgs.cmake;
      pkg-config = pkgs.pkg-config;
      stdenv = pkgs.stdenv;
      makeWrapper = pkgs.makeWrapper;
      python311Packages = numpy-1;
    };
  };

  python-ngx-lsp = pkgs.callPackage ./python-nginx-language-server {
    inherit lib;
    fetchFromGitHub = pkgs.fetchFromGitHub;
    python311Packages = customPydantic;
  };
}
