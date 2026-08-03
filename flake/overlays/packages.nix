{
  inputs,
  pkgs,
  lib,
}:
(import "${inputs.self}/pkgs" {inherit pkgs lib;})
// {
  "0x-proto-nerd-font" = pkgs.callPackage ../../pkgs/0x-proto-nerd-font {
    src = inputs."0x-proto-nerd-font";
  };
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
