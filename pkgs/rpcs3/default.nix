{
  pkgs,
  rpcs3_latest,
  ...
}: {
  pugixml = pkgs.pugixml.overrideAttrs (oldAttrs: rec {
    version = "1.15";
    src = pkgs.fetchurl {
      url = "https://github.com/zeux/pugixml/releases/download/v${version}/pugixml-${version}.tar.gz";
      sha256 = "sha256-ZVreV/pwP7QhwuuaARO1BkvdsUXUFd0fiMeTU9kNURo=";
    };
  });
  SDL3 = pkgs.stdenv.mkDerivation rec {
    pname = "SDL3";
    version = "3.1.3";
    src = pkgs.fetchFromGitHub {
      owner = "libsdl-org";
      repo = "SDL";
      rev = "preview-${version}";
      sha256 = "sha256-S7yRcLHMPgq6+gec8l+ESxp2dJ+6Po/UNsBUXptQzMQ=";
    };
    nativeBuildInputs = [pkgs.cmake];
    buildInputs = [pkgs.libGL pkgs.xorg.libX11 pkgs.xorg.libXext pkgs.alsa-lib];
    cmakeFlags = [
      "-DSDL_STATIC=OFF"
      "-DSDL_SHARED=ON"
      "-DSDL_INSTALL_CMAKEDIR=${placeholder "out"}/lib/cmake/SDL3"
    ];
  };
  rpcs3_latest = pkgs.rpcs3.overrideAttrs (oldAttrs: {
    meta = {
      maintainers = ["Cobray"];
      description = "Latest build of PS3 emulator";
      homepage = "https://rpcs3.net/";
      license = pkgs.lib.licenses.gpl2;
    };
    src = pkgs.fetchgit {
      url = "https://github.com/RPCS3/rpcs3.git";
      rev = rpcs3_latest.rev;
      sha256 = "sha256-efQzZd0EQsvDlAnoMlG+RKjCJiFFj0Iw8BWDoVlRI8c=";
      fetchSubmodules = true;
    };
    patches = [];
    nativeBuildInputs =
      (oldAttrs.nativeBuildInputs or [])
      ++ [
        pkgs.llvmPackages_19.llvm.dev
        pkgs.llvmPackages_19.clang
        pkgs.pkg-config
        pkgs.qt6.qmake
        pkgs.qt6.full
        pkgs.xxd
        pkgs.wayland-scanner
      ];
    buildInputs =
      (oldAttrs.buildInputs or [])
      ++ [
        pkgs.llvmPackages_19.llvm
        pkgs.llvmPackages_19.libclang
        pkgs.qt6.full
        pkgs.vulkan-loader
        pkgs.vulkan-tools
        pkgs.wayland
        pkgs.wayland-protocols
        pkgs.libxkbcommon
        pkgs.libpulseaudio
        pkgs.libevdev
        pkgs.udev
        pkgs.glew
        pkgs.libpng
        pkgs.zstd
      ];
    cmakeFlags =
      (oldAttrs.cmakeFlags or [])
      ++ [
        "-DCMAKE_PREFIX_PATH=${pkgs.qt6.full}:${pkgs.wayland}"
        "-DUSE_SYSTEM_FFMPEG=ON"
        "-DUSE_SYSTEM_CURL=ON"
        "-DUSE_SYSTEM_WOLFSSL=ON"
        "-DUSE_QT=ON"
        "-DUSE_VULKAN=ON"
        "-DUSE_WAYLAND=ON"
        "-DUSE_PULSEAUDIO=ON"
        "-DUSE_LIBEVDEV=ON"
        "-DUSE_SYSTEM_ZSTD=ON"
        "-DUSE_DISCORD_RPC=ON"
        "-DUSE_SDL=OFF"
      ];
  });
}
