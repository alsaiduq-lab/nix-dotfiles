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
    settings = custom.desktop.settings;
  };
  modules = [
    ../../hosts/desktop/configuration.nix

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
          settings = custom.desktop.settings;
          dotfiles = custom.dotfiles;
        };
        sharedModules = [inputs.nixcord.homeModules.nixcord];
        users.${custom.desktop.settings.user} = {
          imports = [
            ../../home-manager/home.nix
            ../../home-manager/modules/desktop
          ];
        };
      };
    }
  ];
}
