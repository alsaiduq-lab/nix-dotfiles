{
  description = "NixOS configuration for Cobray";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
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
            sha256 = "sha256-ZVreV/pwP7QhwuuaARO1BkvdsUXUFd0fiMeTU9kNURo=";
          };
        });
        SDL3 = prev.stdenv.mkDerivation rec {
          pname = "SDL3";
          version = "3.1.3";
          src = prev.fetchFromGitHub {
            owner = "libsdl-org";
            repo = "SDL";
            rev = "preview-${version}";
            sha256 = "sha256-S7yRcLHMPgq6+gec8l+ESxp2dJ+6Po/UNsBUXptQzMQ=";
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
            "-DSDL_CMAKE_DEBUG_POSTFIX="
            "-DSDL_INSTALL_CMAKEDIR=${placeholder "out"}/lib/cmake/SDL3"
          ];
          postInstall = ''
            echo "SDL3 contents:" >&2
            ls -lR $out >&2
            if [ -f "$out/lib/cmake/SDL3/SDL3Config.cmake" ]; then
              echo "SDL3Config.cmake:" >&2
              cat $out/lib/cmake/SDL3/SDL3Config.cmake >&2
            else
              echo "ERROR: SDL3Config.cmake not found" >&2
              exit 1
            fi
          '';
        };
        rpcs3 = prev.rpcs3.overrideAttrs (oldAttrs: {
          nativeBuildInputs =
            (oldAttrs.nativeBuildInputs or [])
            ++ [
              prev.llvmPackages_18.llvm.dev
              prev.llvmPackages_18.clang
              prev.pkg-config
              prev.qt6.qmake
              prev.qt6.full
              prev.xxd
              prev.wayland-scanner
            ];
          buildInputs =
            (oldAttrs.buildInputs or [])
            ++ [
              prev.llvmPackages_18.llvm
              prev.llvmPackages_18.libclang
              final.SDL3
              prev.qt6.full
              prev.vulkan-loader
              prev.vulkan-tools
              prev.wayland
              prev.wayland-protocols
              prev.libxkbcommon
              prev.libpulseaudio
              prev.libevdev
              prev.udev
              prev.glew
              prev.libpng
              prev.zstd
            ];
          cmakeFlags =
            (oldAttrs.cmakeFlags or [])
            ++ [
              "-DCMAKE_PREFIX_PATH=${final.SDL3};${prev.qt6.full};${prev.wayland}"
              "-DSDL3_DIR=${final.SDL3}/lib/cmake/SDL3"
              "-DSDL3_INCLUDE_DIR=${final.SDL3}/include/SDL3"
              "-DSDL3_LIBRARY=${final.SDL3}/lib/libSDL3.so"
              "-DQt6_DIR=${prev.qt6.full}/lib/cmake/Qt6"
              "-DWAYLAND_SCANNER=${prev.wayland-scanner}/bin/wayland-scanner"
              "-DUSE_SYSTEM_FFMPEG=ON"
              "-DUSE_SYSTEM_CURL=ON"
              "-DUSE_SYSTEM_WOLFSSL=ON"
              "-DUSE_QT=ON"
              "-DUSE_VULKAN=ON"
              "-DUSE_WAYLAND=ON"
              "-DUSE_PULSEAUDIO=ON"
              "-DUSE_LIBEVDEV=ON"
              "-DUSE_SYSTEM_ZSTD=ON"
              "-DCMAKE_VERBOSE_MAKEFILE=ON"
              "-DCMake_MESSAGE_LOG_LEVEL=TRACE"
            ];
          preConfigure = ''
            echo "Verifying submodule directories:" >&2
            ls -l 3rdparty/hidapi/hidapi 3rdparty/glslang/glslang 3rdparty/yaml-cpp/yaml-cpp 3rdparty/zstd/zstd >&2
            if [ ! -f 3rdparty/hidapi/hidapi/CMakeLists.txt ]; then
              echo "ERROR: hidapi submodule not fetched correctly" >&2
              exit 1
            fi
            echo "Original 3rdparty/CMakeLists.txt:" >&2
            cat 3rdparty/CMakeLists.txt >&2
            sed -i '/find_package(SDL3/ {
              s/find_package(SDL3.*)/set(SDL3_FOUND TRUE)/
              a set(SDL3_INCLUDE_DIRS "${final.SDL3}/include/SDL3")
              a set(SDL3_LIBRARIES "${final.SDL3}/lib/libSDL3.so")
            }' 3rdparty/CMakeLists.txt
            sed -i 's/message(FATAL_ERROR "SDL3 is not available on this system")/# Patched: SDL3 assumed available/' 3rdparty/CMakeLists.txt
            echo "Patched 3rdparty/CMakeLists.txt:" >&2
            cat 3rdparty/CMakeLists.txt >&2
            echo "Checking submodules:" >&2
            ls -lR 3rdparty/hidapi 3rdparty/glslang 3rdparty/yaml-cpp 3rdparty/cubeb 3rdparty/zstd >&2
          '';
        });
      };
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [customPkgsOverlay];
    };
    lib = nixpkgs.lib;

    rpcs3_latest = pkgs.rpcs3.overrideAttrs (oldAttrs: {
      src = pkgs.fetchgit {
        url = "https://github.com/RPCS3/rpcs3.git";
        rev = inputs.rpcs3-latest.rev; # Should be 37dbd77628f44cdef3228bdfc03127365ec7383b per flake.lock
        sha256 = "sha256-Yx0Qsc0r+5C0BqqsbJCv47QPeaNbaIut8s6Hcysy2mo="; # Confirmed for 37dbd77628f44cdef3228bdfc03127365ec7383b with submodules
        fetchSubmodules = true;
      };
      preUnpack = ''
        echo "Source rev: ${inputs.rpcs3-latest.rev}" >&2
        echo "Expected rev: 37dbd77628f44cdef3228bdfc03127365ec7383b" >&2
      '';
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
