{ pkgs ? import <nixpkgs> {}, lib ? pkgs.lib }:

{
  fish-rust = pkgs.callPackage ./fish-rust {};
  pythonPackages = {
    rembg = pkgs.callPackage ./python-packages/rembg.nix {
      inherit (pkgs) lib stdenv fetchFromGitHub fetchPypi python310;
      inherit (pkgs.python310.pkgs) numpy pillow opencv4 requests onnxruntime;
    };
  };
}
