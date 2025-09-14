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

    unstable = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };

    i3-dotfiles = {
      url = "git+ssh://git@github.com/alsaiduq-lab/i3-dotfiles";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-gaming,
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
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        i3dotfiles = inputs.i3-dotfiles;
      };

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
              (final: prev: {rpcs3 = unstablePkgs.rpcs3;})
              (final: prev: {
                inherit
                  (customPkgs)
                  clear-sans
                  binary-font
                  minijinja-cli
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
            extraSpecialArgs = {
              inherit inputs unstable;
              i3dotfiles = inputs.i3-dotfiles;
            };
            users.cobray = import ./home-manager/cobray.nix;
          };
        }
      ];
    };
  };
}
