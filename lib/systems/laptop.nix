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
    settings = settings.laptop.settings;
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
          inherit inputs rsync;
          settings = settings.laptop.settings;
          dotfiles = settings.dotfiles;
        };
        sharedModules = [inputs.nixcord.homeModules.nixcord];
        users.${settings.laptop.settings.user} = {
          imports = [
            ../../home-manager/home.nix
            ../../home-manager/modules/laptop
            ../../home-manager/modules/workstation
          ];
        };
      };
    }
  ];
}
