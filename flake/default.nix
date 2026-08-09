{inputs}: let
  inherit (inputs) nixpkgs home-manager;

  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };

  unstablePkgs = import inputs.unstable {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };

  customPkgs = import ./overlays/packages.nix {
    inherit pkgs inputs;
    lib = nixpkgs.lib;
  };

  custom = import ./custom.nix {
    inherit inputs;
  };

  overlays = import ./overlays {
    inherit inputs system unstablePkgs customPkgs;
  };

  inherit (pkgs) rsync;
in {
  packages.${system} = customPkgs;

  nixosConfigurations = {
    desktop = import ./systems/desktop.nix {
      inherit inputs nixpkgs home-manager pkgs overlays custom rsync;
    };

    laptop = import ./systems/laptop.nix {
      inherit inputs nixpkgs home-manager pkgs overlays custom rsync;
    };

    magus = import ./systems/server.nix {
      inherit inputs nixpkgs home-manager pkgs overlays custom rsync;
    };
  };
}
