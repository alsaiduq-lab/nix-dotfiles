{
  description = "NixOS configuration for Cobray";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rpcs3_latest = {
      url = "github:RPCS3/rpcs3";
      flake = false;
    };
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-gaming,
    rpcs3_latest,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    customPkgs = import "${self}/pkgs" {
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
      inherit rpcs3_latest;
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs customPkgs;
        lib = nixpkgs.lib;
      };
      modules = [
        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [
            (final: prev: {
              inherit
                (customPkgs)
                fish-rust
                pugixml
                SDL3
                rpcs3_latest
                ;
            })
          ];
        }
        ./hosts/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs customPkgs;
            };
            users.cobray = import ./home-manager/cobray.nix;
          };
        }
      ];
    };
  };
}
