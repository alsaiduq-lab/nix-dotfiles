{
  description = "NixOS configuration (hyprland) for Cobray";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
    };

    nix-monitor = {
      url = "github:antonjah/nix-monitor";
    };

    proton-cachyos = {
      url = "github:Arsalan2356/proton-cachyos-flake";
    };

    aagl = {
      url = "github:alsaiduq-lab/aagl-gtk-on-nix";
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
      inputs.quickshell.follows = "quickshell";
    };

    nvim-dots = {
      url = "github:alsaiduq-lab/nvim-dotfiles";
      flake = false;
    };

    hyprland-dots = {
      url = "git+ssh://git@github.com/alsaiduq-lab/hyprland-dots";
      flake = false;
    };

    firefly-cursor = {
      url = "git+ssh://git@github.com/alsaiduq-lab/animated-cursors?ref=firefly";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    grim-hyprland = {
      url = "github:eriedaberrie/grim-hyprland";
    };

    linux-desktop-gremlin = {
      url = "git+file:////home/cobray/linux-desktop-gremlin?ref=nix";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
    };

    dw-proton = {
      url = "github:Momoyaan/dwproton-flake";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # vps OOMs when trying to nix-index with 8 GB of ram
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
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
    firefly-cursor,
    dankMaterialShell,
    pinix,
    disko,
    nix-index-database,
    aagl,
    dw-proton,
    #sops-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = nixpkgs.legacyPackages.${system};
    unstablePkgs = import unstable {
      inherit system;
      config.allowUnfree = true;
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
        clear-sans
        binary-font
        dms-plugins
        ;
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
                quickshell = inputs.quickshell.packages.${system}.default.withModules [final.qt6Packages.qtwebsockets];
                ghostty = inputs.ghostty.packages.${system}.default;
                firefly-cursor = inputs.firefly-cursor.packages.${system}.default;
                grim-hyprland = inputs.grim-hyprland.packages.${system}.default;
                dms-shell = inputs.dankMaterialShell.packages.${system}.default;
                pinix = inputs.pinix.packages.${system}.default;
                wine-tkg = inputs.nix-gaming.packages.${system}.wine-tkg;
                proton-cachyos = inputs.proton-cachyos.packages.${system}.proton-cachyos;
                desktop-gremlin = inputs.linux-desktop-gremlin.packages.${system}.default;
                ipc-bridge = inputs.nix-gaming.packages.${system}.wine-discord-ipc-bridge;
                dgop = unstablePkgs.dgop;
                hyprland = inputs.hyprland.packages.${system}.default;
                dw-proton = inputs.dw-proton.packages.${system}.default;
                ollama = unstablePkgs.ollama-cuda;
              })
              (final: prev: {
                inherit
                  (customPkgs)
                  clear-sans
                  binary-font
                  minijinja-cli
                  thorium
                  rpcs3
                  dms-plugins
                  ;
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
              nvimDots = inputs.nvim-dots;
              dankMaterialShell = inputs.dankMaterialShell.packages.${system}.default;
            };
            sharedModules = [
              inputs.nixcord.homeModules.nixcord
              inputs.nix-monitor.homeManagerModules.default
            ];
            users.cobray = import ./home-manager/cobray.nix;
          };
        }
      ];
    };

    # server
    nixosConfigurations.magus = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      modules = [
        disko.nixosModules.disko
        nix-index-database.nixosModules.nix-index
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
                pinix = inputs.pinix.packages.${system}.default;
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
              nvimDots = inputs.nvim-dots;
              hyprlanddots = inputs.hyprland-dots;
            };
            users.alteur = import ./home-manager/alteur.nix;
          };
        }
      ];
    };
  };
}
