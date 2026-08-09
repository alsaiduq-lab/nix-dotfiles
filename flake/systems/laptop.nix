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
    settings = custom.laptop.settings;
  };
  modules = [
    ../../hosts/laptop/configuration.nix

    inputs.aagl.nixosModules.default
    home-manager.nixosModules.home-manager
    inputs.dank-greeter.nixosModules.default

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
          settings = custom.laptop.settings;
          dotfiles = custom.dotfiles;
        };
        sharedModules = [inputs.nixcord.homeModules.nixcord];
        users.${custom.laptop.settings.user} = {
          imports = [
            ../../home-manager/home.nix
            ../../home-manager/modules/laptop
          ];
        };
      };
    }
  ];
}
