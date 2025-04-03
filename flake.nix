{
  description = "NixOS configuration for Cobray";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming"; # for glorious eggrolls
    };
    rpcs3-latest = {
      url = "github:RPCS3/rpcs3";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-gaming,
    rpcs3-latest,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    customPkgsOverlay = final: prev: let
      customPkgs = import ./pkgs {
        pkgs = prev;
        lib = prev.lib;
      };
    in
      customPkgs
      // {
        pugixml = prev.pugixml.overrideAttrs (oldAttrs: rec {
          version = "1.15";
          src = prev.fetchurl {
            url = "https://github.com/zeux/pugixml/releases/download/v${version}/pugixml-${version}.tar.gz";
            sha256 = "ZVreV/pwP7QhwuuaARO1BkvdsUXUFd0fiMeTU9kNURo=";
          };
        });
        SDL3 = prev.stdenv.mkDerivation rec {
          pname = "SDL3";
          version = "3.1.3";
          src = prev.fetchFromGitHub {
            owner = "libsdl-org";
            repo = "SDL";
            rev = "preview-${version}";
            sha256 = "XQwcl/udA+r5HJs21K+GtZ2GIXfXUHjYTXFYW4Yx+Do=";
          };
          nativeBuildInputs = [prev.cmake];
          buildInputs = [
            prev.libGL
            prev.xorg.libX11
            prev.xorg.libXext
            prev.alsa-lib
          ];
          cmakeFlags = [
            "-DSDL_STATIC=OFF"
            "-DSDL_SHARED=ON"
          ];
        };
        rpcs3 = prev.rpcs3.overrideAttrs (oldAttrs: {
          nativeBuildInputs =
            (oldAttrs.nativeBuildInputs or [])
            ++ [
              prev.llvmPackages_18.llvm.dev
              prev.llvmPackages_18.clang
            ];
          buildInputs =
            (oldAttrs.buildInputs or [])
            ++ [
              prev.llvmPackages_18.llvm
              prev.llvmPackages_18.libclang
              final.SDL3
            ];
        });
      };
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [customPkgsOverlay];
    };
    lib = nixpkgs.lib;

    rpcs3_latest = pkgs.rpcs3.overrideAttrs (oldAttrs: {
      src = rpcs3-latest;
    });
  in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          {nixpkgs.overlays = [customPkgsOverlay];}
          ./hosts/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "cobray" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs rpcs3_latest;};
        modules = [./home-manager/cobray.nix];
      };
    };
  };
}
