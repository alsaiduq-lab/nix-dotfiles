{
  inputs,
  nixpkgs,
  home-manager,
  pkgs,
  overlays,
  custom,
  rsync,
}:
nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit inputs;
    settings = custom.server.settings;
  };
  modules = [
    ../../hosts/server/magus.nix

    inputs.disko.nixosModules.disko
    inputs.nix-index-database.nixosModules.nix-index
    inputs.copyparty.nixosModules.default
    inputs.hermes-agent.nixosModules.default
    home-manager.nixosModules.home-manager

    {
      nixpkgs = {inherit pkgs overlays;};
    }
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        extraSpecialArgs = {
          inherit inputs custom rsync;
          settings = custom.server.settings;
          dotfiles = custom.dotfiles;
        };
        users.${custom.server.settings.user} = {
          imports = [
            ../../home-manager/home.nix
            ../../home-manager/modules/server
          ];
        };
      };
    }
  ];
}
