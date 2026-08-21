{
  inputs,
  nixpkgs,
  home-manager,
  pkgs,
  overlays,
  settings,
  rsync,
}:
nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit inputs;
    settings = settings.server.settings;
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
          inherit inputs rsync;
          settings = settings.server.settings;
          dotfiles = settings.dotfiles;
        };
        users.${settings.server.settings.user} = {
          imports = [
            ../../home-manager/home.nix
            ../../home-manager/modules/server
          ];
        };
      };
    }
  ];
}
