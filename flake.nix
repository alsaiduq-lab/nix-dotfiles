{
  description = "bloated rice";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

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
      url = "github:alsaiduq-lab/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    unstable = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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

    hyprland-dots = {
      url = "git+ssh://git@github.com/alsaiduq-lab/hyprland-dots";
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
      url = "github:alsaiduq-lab/linux-desktop-gremlin/nix";
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

    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    soul = {
      url = "git+ssh://forgejo@git.monaie.ca/alteur/soul";
      flake = false;
    };

    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
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
    nix-gaming,
    unstable,
    sops-nix,
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
        vita3k
        ryubing
        ;
    };
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        hyprlanddots = inputs.hyprland-dots;
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
            overlays = [
              (final: prev: {
                quickshell = inputs.quickshell.packages.${system}.default.withModules [final.qt6Packages.qtwebsockets];
                ghostty = inputs.ghostty.packages.${system}.default;
                miku-cursor = inputs.miku-cursor.packages.${system}.default;
                grim-hyprland = inputs.grim-hyprland.packages.${system}.default;
                proton-cachyos = inputs.proton-cachyos.packages.${system}.proton-cachyos;
                desktop-gremlin = inputs.linux-desktop-gremlin.packages.${system}.default;
                dgop = unstablePkgs.dgop;
                hyprland = inputs.hyprland.packages.${system}.default;
                dw-proton = inputs.dw-proton.packages.${system}.default;
                ollama = unstablePkgs.ollama-cuda;
                ryubing = customPkgs.ryubing;
                python313 = prev.python313.override {
                  packageOverrides = pyfinal: pyprev: {
                    pyqtgraph = pyprev.pyqtgraph.overridePythonAttrs (_: {doCheck = false;});
                  };
                };
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
              hyprlanddots = inputs.hyprland-dots;
              nvimDots = inputs.nvim-dots;
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
                  ;
              })
              (final: prev: {
                clear-sans = prev.clear-sans.clear-sans;
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
