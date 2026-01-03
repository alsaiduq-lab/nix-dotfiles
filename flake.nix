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

    proton-cachyos = {
      url = "github:Arsalan2356/proton-cachyos-flake";
    };

    aagl = {
      url = "github:alsaiduq-lab/aagl-gtk-on-nix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
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

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
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

    linux-desktop-gremlin = {
      url = "github:iluvgirlswithglasses/linux-desktop-gremlin";
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
    aagl,
    #sops-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = nixpkgs.legacyPackages.${system};
    unstablePkgs = unstable.legacyPackages.${system};

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
      specialArgs = {
        inherit inputs;
        hyprlanddots = inputs.hyprland-dots;
      };

      modules = [
        aagl.nixosModules.default
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
                dmsCli = inputs.dankMaterialShell.packages.${system}.default;
                dankMaterialShell = inputs.dankMaterialShell.packages.${system}.dankMaterialShell;
                pinix = inputs.pinix.packages.${system}.default;
                wine-cachyos = inputs.nix-gaming.packages.${system}.wine-cachyos;
                proton-cachyos = inputs.proton-cachyos.packages.${system}.proton-cachyos;
                desktop-gremlin = inputs.linux-desktop-gremlin.packages.${system}.default;
                ipc-bridge = inputs.nix-gaming.packages.${system}.wine-discord-ipc-bridge;
                dgop = unstablePkgs.dgop;
                hyprland = inputs.hyprland.packages.${system}.default;
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
                pinix = inputs.pinix.packages.${system}.default;
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
