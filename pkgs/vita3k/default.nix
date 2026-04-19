{
  lib,
  appimageTools,
  buildFHSEnv,
  fetchurl,
  writeShellScript,
  SDL2,
  gtk3,
  openssl,
  vulkan-loader,
  libGL,
  xdg-desktop-portal,
  libx11,
  libxcursor,
  libxrandr,
  libxi,
  libxext,
  libxinerama,
  libxkbcommon,
  libsm,
  libice,
  zlib,
  libgpg-error,
  libpulseaudio,
  alsa-lib,
  systemd,
  wayland,
}: let
  pname = "vita3k";
  version = "3920";

  src = fetchurl {
    url = "https://github.com/Vita3K/Vita3K-builds/releases/download/${version}/Vita3K-x86_64.AppImage";
    hash = "sha256-xQAYXFW1ytO1iB60AtMYWDs18dzyjtzT68vyDuc/N5s=";
  };

  contents = appimageTools.extractType2 {inherit pname version src;};
in
  buildFHSEnv {
    inherit pname version;

    targetPkgs = pkgs: [
      SDL2
      gtk3
      openssl
      vulkan-loader
      libGL
      xdg-desktop-portal
      libx11
      libxcursor
      libxrandr
      libxi
      libxext
      libxinerama
      libxkbcommon
      libsm
      libice
      zlib
      libgpg-error
      libpulseaudio
      alsa-lib
      systemd
      wayland
    ];

    runScript = writeShellScript "vita3k-wrapper" ''
      DATA_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/Vita3K"
      mkdir -p "$DATA_DIR"
      for dir in shaders-builtin data lang; do
        if [ ! -e "$DATA_DIR/$dir" ]; then
          ln -sf ${contents}/usr/share/Vita3K/$dir "$DATA_DIR/$dir"
        fi
      done
      exec env VK_LAYER_PATH= ${contents}/usr/bin/Vita3K "$@"
    '';

    extraInstallCommands = ''
      install -Dm644 ${contents}/usr/share/applications/vita3k.desktop $out/share/applications/vita3k.desktop
      substituteInPlace $out/share/applications/vita3k.desktop \
        --replace-warn "Exec=vita3k" "Exec=${pname}"
      install -Dm644 ${contents}/usr/share/icons/hicolor/128x128/apps/vita3k.png \
        $out/share/icons/hicolor/128x128/apps/vita3k.png
    '';

    meta = {
      description = "PlayStation Vita emulator";
      homepage = "https://vita3k.org/";
      license = lib.licenses.gpl2Only;
      platforms = ["x86_64-linux"];
      maintainers = ["Hibiki"];
      mainProgram = "vita3k";
    };
  }
