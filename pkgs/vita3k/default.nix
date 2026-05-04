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
  updateDeps,
}: let
  pname = "vita3k";
  deps = builtins.fromJSON (builtins.readFile ./deps.json);
  version = deps.version;
  source = {
    owner = "Vita3K";
    repo = "Vita3K-builds";
    asset = "Vita3K-x86_64.AppImage";
  };
  resourceDirs = [
    "data"
    "lang"
    "shaders-builtin"
  ];

  src = fetchurl {
    url = "https://github.com/${source.owner}/${source.repo}/releases/download/${version}/${source.asset}";
    hash = deps.src.hash;
  };

  contents = appimageTools.extractType2 {inherit pname version src;};
in
  buildFHSEnv {
    inherit pname version;

    passthru = {
      depsFile = "pkgs/vita3k/deps.json";
      "update-deps" = updateDeps.fetchGitHubReleaseAsset (source // {
        name = pname;
      });
    };

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
      set -euo pipefail

      dataDir="''${XDG_DATA_HOME:-''${HOME:?HOME must be set}/.local/share}/Vita3K"
      mkdir -p "$dataDir"

      configDir="''${XDG_CONFIG_HOME:-''${HOME:?HOME must be set}/.config}/Vita3K"
      configFile="$configDir/config.yml"
      if [ ! -e "$configFile" ]; then
        mkdir -p "$configDir"
        touch "$configFile"
      fi

      for dir in ${lib.escapeShellArgs resourceDirs}; do
        target="$dataDir/$dir"
        if [ -e "$target" ]; then
          continue
        fi
        if [ -L "$target" ]; then
          rm -f "$target"
        fi
        ln -s ${contents}/usr/share/Vita3K/"$dir" "$target"
      done

      export APPDIR=${contents}
      export APPIMAGE=${src}
      exec env VK_LAYER_PATH= ${contents}/usr/bin/Vita3K "$@"
    '';

    extraInstallCommands = ''
      install -Dm644 ${contents}/usr/share/applications/vita3k.desktop $out/share/applications/vita3k.desktop
      substituteInPlace $out/share/applications/vita3k.desktop \
        --replace-fail "Exec=Vita3K" "Exec=${pname}"
      cp -R ${contents}/usr/share/icons $out/share/
    '';

    meta = {
      description = "PlayStation Vita emulator";
      homepage = "https://vita3k.org/";
      license = lib.licenses.gpl2Only;
      platforms = ["x86_64-linux"];
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      maintainers = ["Hibiki"];
      mainProgram = "vita3k";
    };
  }
