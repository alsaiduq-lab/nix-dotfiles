{
  pkgs,
  lib,
  wine-cachyos,
}: {
  clear-sans = pkgs.callPackage ./clear-sans {};
  binary-font = pkgs.callPackage ./binary-font {};
  minijinja-cli = pkgs.callPackage ./minijinja-cli {};
  thorium = pkgs.callPackage ./thorium {};
  rpcs3 = pkgs.callPackage ./rpcs3 {};
  wine-cachyos = pkgs.callPackage ./wine-cachyos {inherit wine-cachyos;};
}
