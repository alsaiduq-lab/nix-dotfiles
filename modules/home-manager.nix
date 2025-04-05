{
  inputs,
  rpcs3_latest,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs rpcs3_latest;
    };
    users.cobray = import ../home-manager/cobray.nix;
  };
}
