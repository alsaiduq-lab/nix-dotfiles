{
  description = "NixOS configuration for Cobray";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-gaming,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    customPkgsOverlay = final: prev:
      import ./pkgs {
        pkgs = prev;
        lib = prev.lib;
      };
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [customPkgsOverlay];
    };
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          {nixpkgs.overlays = [customPkgsOverlay];}
          ./hosts/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "cobray" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};
        modules = [./home-manager/cobray.nix];
      };
    };
  };
}
