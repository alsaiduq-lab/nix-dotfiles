{
  pkgs,
  lib,
}: let
  update = import ./update.nix {inherit pkgs lib;};
  inherit (update) updateDeps;

  packageSet = rec {
    clear-sans = pkgs.callPackage ./clear-sans {inherit updateDeps;};
    minijinja-cli = pkgs.callPackage ./minijinja-cli {inherit updateDeps;};
    thorium = pkgs.callPackage ./thorium {inherit updateDeps;};
    rpcs3 = pkgs.callPackage ./rpcs3 {inherit updateDeps;};
    vita3k = pkgs.callPackage ./vita3k {inherit updateDeps;};
    ryubing = pkgs.callPackage ./ryubing {inherit updateDeps;};
    dms-plugins = {
      lyrics-on-panel = pkgs.callPackage ./dms-plugins/lyrics-on-panel {inherit updateDeps;};
    };
  };

  packages =
    packageSet
    // {
      update-deps = update.updateAll packageSet;
    };
in
  packages
