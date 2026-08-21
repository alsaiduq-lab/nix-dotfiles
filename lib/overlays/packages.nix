{
  inputs,
  pkgs,
  lib,
}:
(import "${inputs.self}/pkgs" {inherit pkgs lib;})
// {
  clear-sans = pkgs.callPackage ../../pkgs/clear-sans {
    src = inputs.clear-sans;
  };
  dms-lyrics-on-panel = pkgs.callPackage ../../pkgs/dms-lyrics-on-panel {
    src = inputs.dms-lyrics-on-panel;
  };
  linux-arctis-manager = pkgs.callPackage ../../pkgs/linux-arctis-manager {
    src = inputs.linux-arctis-manager;
  };
}
