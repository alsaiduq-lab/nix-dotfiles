{ inputs, pkgs, lib, rpcs3_latest, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.cobray = import ../home-manager/cobray.nix {
      inherit pkgs lib rpcs3_latest;
    };
  };
}
