{
  description = "NixOS configuration for Cobray";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming"; # for glorious eggrolls
    };
    rpcs3-latest = {
      url = "github:RPCS3/rpcs3";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-gaming,
    rpcs3-latest,
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

    rpcs3_latest = pkgs.rpcs3.overrideAttrs (oldAttrs: {
      src = rpcs3-latest;
    });
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
        extraSpecialArgs = {inherit inputs rpcs3_latest;};
        modules = [./home-manager/cobray.nix];
      };
    };
  };
}
