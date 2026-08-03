{inputs}: let
  inherit (inputs) nixpkgs home-manager;

  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
      allowAliases = true;
    };
  };

  unstablePkgs = import inputs.unstable {
    inherit system;
    config = {
      allowUnfree = true;
      allowAliases = true;
    };
  };

  customPkgs = import ./overlays/packages.nix {
    inherit pkgs inputs;
    lib = nixpkgs.lib;
  };

  custom = import ./custom.nix {
    inherit inputs;
  };

  inherit (pkgs) rsync;
in {
  packages.${system} = customPkgs;

  nixosConfigurations = {
    desktop = import ./systems/desktop.nix {
      inherit inputs nixpkgs home-manager system custom rsync;
      overlays = import ./overlays {
        inherit inputs system unstablePkgs customPkgs;
      };
    };

    laptop = import ./systems/laptop.nix {
      inherit inputs nixpkgs home-manager system custom rsync;
      overlays = import ./overlays {
        inherit inputs system unstablePkgs customPkgs;
      };
    };

    magus = import ./systems/server.nix {
      inherit inputs nixpkgs home-manager system custom rsync;
      overlays = import ./overlays {
        inherit inputs system unstablePkgs customPkgs;
      };
    };
  };
}
