{
  description = "NixOS configuration (hyprland) for Cobray";

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

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-dots = {
      url = "github:alsaiduq-lab/nvim-dotfiles";
      flake = false;
    };

    hyprland-dots = {
      url = "git+ssh://git@github.com/alsaiduq-lab/hyprland-dots";
      flake = false;
    };

    hu-tao-cursor = {
      url = "git+ssh://git@github.com/alsaiduq-lab/Hu-Tao-Animated-Cursor";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    grim-hyprland = {
      url = "github:eriedaberrie/grim-hyprland";
    };

    # TODO: sops-nix = {
    #   url = "github:Mic92/sops-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    hyprspace = {
      url = "github:KZDKM/Hyprspace/7a3adf6";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-gaming,
    unstable,
    ghostty,
    hu-tao-cursor,
    #sops-nix,
    hyprspace,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
    };

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
        hyprlanddots = inputs.hyprland-dots;
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
              (final: prev: {
                ollama = unstablePkgs.ollama-cuda;
                rpcs3 = unstablePkgs.rpcs3;
                quickshell = unstable.legacyPackages.${system}.quickshell;
                ghostty = inputs.ghostty.packages.${system}.default;
                hu-tao-animated-cursor = inputs.hu-tao-cursor.packages.${system}.default;
                grim-hyprland = inputs.grim-hyprland.packages.${system}.default;
                hyprspace = inputs.hyprspace.packages.${system}.default;
              })
              (final: prev: {
                inherit
                  (customPkgs)
                  clear-sans
                  binary-font
                  minijinja-cli
                  thorium
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
              hyprlanddots = inputs.hyprland-dots;
              nvimDotfiles = inputs.nvim-dots;
            };
            users.cobray = import ./home-manager/cobray.nix;
          };
        }
      ];
    };
  };
}
