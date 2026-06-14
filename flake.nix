{
  description = "bloated rice";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:alsaiduq-lab/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms-plugins-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-dots = {
      url = "github:alsaiduq-lab/nvim-dotfiles";
      flake = false;
    };

    tokyo-night = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };

    miku-cursor = {
      url = "git+https://git.monaie.ca/alteur/animated-cursors";
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

    nixcord = {
      url = "github:FlameFlag/nixcord";
    };

    dw-proton = {
      url = "github:Momoyaan/dwproton-flake";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    modernx = {
      url = "github:cyl0/ModernX?ref=0.6.1";
      flake = false;
    };

    anime4k = {
      url = "github:bloc97/Anime4K?ref=v4.0.1";
      flake = false;
    };

    nvm-fish = {
      url = "github:jorgebucaran/nvm.fish";
      flake = false;
    };

    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    sops-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowAliases = true;
      };
    };

    unstablePkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowAliases = true;
      };
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
        vita3k
        ryubing
        ani-cli
        update-deps
        ;
    };
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };

      modules = [
        inputs.aagl.nixosModules.default
        {
          nixpkgs = {
            config = {
              allowUnfree = true;
              allowAliases = true;
            };
            hostPlatform = system;
            # TODO: move to seperate file
            overlays = [
              (final: prev: {
                quickshell = inputs.quickshell.packages.${system}.default.withModules [final.qt6Packages.qtwebsockets];
                ghostty = inputs.ghostty.packages.${system}.default;
                miku-cursor = inputs.miku-cursor.packages.${system}.default;
                grim-hyprland = inputs.grim-hyprland.packages.${system}.default;
                desktop-gremlin = inputs.linux-desktop-gremlin.packages.${system}.default;
                dgop = unstablePkgs.dgop;
                hyprland = inputs.hyprland.packages.${system}.default;
                dw-proton = inputs.dw-proton.packages.${system}.default;
                ollama = unstablePkgs.ollama-cuda;
                ryubing = customPkgs.ryubing;
                ani-cli = customPkgs.ani-cli;
                pkgsi686Linux = prev.pkgsi686Linux.extend (ifinal: iprev: {
                  openldap = iprev.openldap.overrideAttrs (_: {doCheck = false;});
                });
              })
              (final: prev: {
                inherit
                  (customPkgs)
                  clear-sans
                  minijinja-cli
                  thorium
                  rpcs3
                  vita3k
                  ryubing
                  ani-cli
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
            backupFileExtension = "bak";
            extraSpecialArgs = {
              inherit inputs;
              nvimDots = inputs.nvim-dots;
              tokyo-night = inputs.tokyo-night;
              modernx = inputs.modernx;
              anime4k = inputs.anime4k;
              nvm-fish = inputs.nvm-fish;
            };
            sharedModules = [
              inputs.nixcord.homeModules.nixcord
            ];
            users.hibiki = import ./home-manager/hibiki.nix;
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
        inputs.disko.nixosModules.disko
        inputs.nix-index-database.nixosModules.nix-index
        inputs.copyparty.nixosModules.default
        inputs.sops-nix.nixosModules.sops
        inputs.hermes-agent.nixosModules.default
        {
          nixpkgs = {
            config = {
              allowUnfree = true;
              allowAliases = true;
            };
            hostPlatform = system;
            overlays = [
              inputs.copyparty.overlays.default
              (final: prev: {
                inherit
                  (customPkgs)
                  minijinja-cli
                  clear-sans
                  ;
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
            backupFileExtension = "bak";
            extraSpecialArgs = {
              inherit inputs;
              nvimDots = inputs.nvim-dots;
              tokyo-night = inputs.tokyo-night;
              nvm-fish = inputs.nvm-fish;
            };
            users.alteur = import ./home-manager/alteur.nix;
          };
        }
      ];
    };
  };
}
