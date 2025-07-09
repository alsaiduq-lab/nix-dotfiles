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

    hrtowii = {
      url = "git+https://github.com/hrtowii/dotfiles?dir=nixos/home-manager/config/quickshell";
      flake = false;
    };

    astal = {
      url = "github:aylur/ags";
    };

    i3-dotfiles = {
      url = "git+ssh://git@github.com/alsaiduq-lab/i3-dotfiles";
      flake = false;
    };
    # see: https://github.com/ghostty-org/ghostty/commit/20c6a6fcf2a1dc72d6a60ad2f6e58cba14e4fb2f
    ghostty = {
      url = "github:ghostty-org/ghostty/20c6a6fcf2a1dc72d6a60ad2f6e58cba14e4fb2f";
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
              (final: prev: {quickshell = inputs.hrtowii;})
              (final: prev: {
                ghostty = inputs.ghostty.packages.${system}.default;
              })
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
              inherit inputs;
              i3dotfiles = inputs.i3-dotfiles;
            };
            users.cobray = import ./home-manager/cobray.nix;
          };
        }
      ];
    };
  };
}
