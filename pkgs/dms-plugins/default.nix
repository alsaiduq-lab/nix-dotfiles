{
  pkgs,
  updateDeps,
}: {
  lyrics-on-panel = pkgs.callPackage ./lyrics-on-panel {inherit updateDeps;};
}
