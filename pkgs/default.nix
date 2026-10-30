{
  pkgs,
  lib,
}: let
  entries =
    lib.filterAttrs (name: type:
      type == "directory" && builtins.pathExists (./. + "/${name}/default.nix")) (builtins.readDir ./.);

  packages = lib.mapAttrs (name: _: let
    package = pkgs.callPackage (./. + "/${name}") {};
  in
    if lib.isDerivation package
    then package
    else throw "no default.nix in pkgs/${name}/")
  entries;

  refresh = import ./refresh.nix {inherit pkgs lib packages;};
in
  packages
  // {
    refresh-deps = refresh;
  }
