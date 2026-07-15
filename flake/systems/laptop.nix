{
  inputs,
  nixpkgs,
  home-manager,
  system,
  overlays,
  custom,
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

    {
      nixpkgs = {
        config = {
          allowUnfree = true;
          allowAliases = true;
        };
        hostPlatform = system;
        inherit overlays;
      };
    }
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        extraSpecialArgs = {
          inherit inputs custom;
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
