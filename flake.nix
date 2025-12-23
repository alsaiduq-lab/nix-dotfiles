{
  description = "NixOS configuration (hyprland) for Cobray";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
    };

    unstable = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };

    pinix = {
      url = "github:remi-dupre/pinix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dgop.follows = "dgop";
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

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: sops-nix = {
    #   url = "github:Mic92/sops-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
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
    dankMaterialShell,
    pinix,
    disko,
    #sops-nix,
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
    packages.${system} = {
      inherit
        (customPkgs)
        minijinja-cli
        thorium
        rpcs3
        ;
      clear-sans = customPkgs.clear-sans.clear-sans;
      binary-font = customPkgs.binary-font.binary-clock-font;
    };
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
                quickshell = inputs.quickshell.packages.${system}.default;
                ghostty = inputs.ghostty.packages.${system}.default;
                hu-tao-animated-cursor = inputs.hu-tao-cursor.packages.${system}.default;
                grim-hyprland = inputs.grim-hyprland.packages.${system}.default;
                dgop = inputs.dgop.packages.${system}.default;
                dmsCli = inputs.dankMaterialShell.packages.${system}.default;
                dankMaterialShell = inputs.dankMaterialShell.packages.${system}.dankMaterialShell;
                pinix = inputs.pinix.packages.${system}.default;
                wine-cachyos = inputs.nix-gaming.packages.${system}.wine-cachyos;
              })
              (final: prev: {
                inherit
                  (customPkgs)
                  clear-sans
                  binary-font
                  minijinja-cli
                  thorium
                  rpcs3
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
              dankMaterialShell = inputs.dankMaterialShell.packages.${system}.default;
            };
            users.cobray = import ./home-manager/cobray.nix;
          };
        }
      ];
    };

    nixosConfigurations.magus = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
      };
      modules = [
        disko.nixosModules.disko
        {
          nixpkgs = {
            config = {
              allowUnfree = true;
              allowAliases = true;
            };
            hostPlatform = system;
            overlays = [
              (final: prev: {
                inherit
                  (customPkgs)
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
        ./hosts/magus.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs;
              nvimDotfiles = inputs.nvim-dots;
            };
          };
        }
      ];
    };
  };
}
