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

    unstable = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-gaming,
    rpcs3_latest,
    unstable,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = nixpkgs.legacyPackages.${system};

    unstablePkgs = import unstable {
      inherit system;
      config = {allowUnfree = true;};
    };

    customPkgs = import "${self}/pkgs" {
      inherit pkgs;
      lib = nixpkgs.lib;
      inherit rpcs3_latest;
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};

      modules = [
        {
          nixpkgs = {
            config = {
              allowUnfree = true;
              allowAliases = true;
            };
            hostPlatform = system;
            overlays = [
              (final: prev: {ollama = unstablePkgs.ollama;})
              (final: prev: {
                inherit
                  (customPkgs)
                  fish-rust
                  pugixml
                  SDL3
                  rpcs3_latest
                  clear-sans
                  binary-font
                  ;
              })

              (final: prev: {
                clear-sans = prev.clear-sans.clear-sans;
                binary-font = prev.binary-font.binary-clock-font;
              })
            ];
          };
        }
        ./hosts/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit inputs;};
            users.cobray = import ./home-manager/cobray.nix;
          };
        }
      ];
    };
  };
}
