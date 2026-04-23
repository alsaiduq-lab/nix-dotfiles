{
  pkgs,
  lib,
}: {
  clear-sans = pkgs.callPackage ./clear-sans {};
  minijinja-cli = pkgs.callPackage ./minijinja-cli {};
  thorium = pkgs.callPackage ./thorium {};
  rpcs3 = pkgs.callPackage ./rpcs3 {};
  vita3k = pkgs.callPackage ./vita3k {};
  ryubing = pkgs.callPackage ./ryubing {};
  dms-plugins = {
    lyrics-on-panel = pkgs.callPackage ./dms-plugins/lyrics-on-panel {};
  };
}
