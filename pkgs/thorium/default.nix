{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  dpkg,
  xdg-utils,
  hicolor-icon-theme,
  nss,
  nspr,
  glib,
  gtk3,
  at-spi2-core,
  dbus,
  libdrm,
  libgbm,
  libGL,
  libX11,
  libXext,
  libXdamage,
  libXfixes,
  libXcomposite,
  libXrandr,
  libXcursor,
  libXrender,
  libXi,
  libXtst,
  libXScrnSaver,
  libxcb,
  libxkbcommon,
  alsa-lib,
  cups,
  pango,
  cairo,
  libva,
  libvdpau,
  expat,
  zlib,
  libnotify,
  libuuid,
  libsecret,
  libkrb5,
  libpng,
  freetype,
  fontconfig,
  systemd,
  pipewire,
  gnome-settings-daemon,
  updateDeps,
}: let
  pname = "thorium-browser";
  version = "144.0.7559.254";
  deps = builtins.fromJSON (builtins.readFile ./deps.json);
  source = {
    owner = "gz83";
    repo = "thorium";
    tag = version: "M${version}";
    asset = version: "thorium-browser_${version}_AVX2.deb";
  };
in
  stdenv.mkDerivation (finalAttrs: {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/${source.owner}/${source.repo}/releases/download/${source.tag version}/${source.asset version}";
      hash = deps.src.hash;
    };

    passthru = {
      depsFile = "pkgs/thorium/deps.json";
      "update-deps" = updateDeps.fetchGitHubReleaseAsset (source // {
        name = pname;
      });
    };

    strictDeps = true;

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      dpkg
    ];

    buildInputs = [
      nss
      nspr
      glib
      gtk3
      at-spi2-core
      dbus
      libdrm
      libgbm
      libGL
      libX11
      libXext
      libXdamage
      libXfixes
      libXcomposite
      libXrandr
      libXcursor
      libXrender
      libXi
      libXtst
      libXScrnSaver
      libxcb
      libxkbcommon
      alsa-lib
      cups
      pango
      cairo
      libva
      libvdpau
      expat
      zlib
      libnotify
      libuuid
      libsecret
      libkrb5
      libpng
      freetype
      fontconfig
      systemd
      pipewire
    ];

    propagatedBuildInputs = [hicolor-icon-theme];
    unpackPhase = ''
      runHook preUnpack
      dpkg-deb --fsys-tarfile "$src" | tar --no-same-owner --no-same-permissions -xf -
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/{opt/thorium,bin,share/applications}
      cp -r $(find opt -type d -name thorium | head -1)/* $out/opt/thorium/
      rm -f $out/opt/thorium/libqt{5,6}_shim.so
      ln -sf $out/opt/thorium/thorium $out/bin/thorium
      ln -sf $out/bin/thorium $out/bin/thorium-browser
      if [ -f usr/share/applications/thorium-browser.desktop ]; then
        sed -E \
          -e "s|^Exec=.*|Exec=$out/bin/thorium %U|" \
          usr/share/applications/thorium-browser.desktop > $out/share/applications/thorium-browser.desktop
      fi
      mkdir -p $out/share/icons/hicolor
      cp ${hicolor-icon-theme}/share/icons/hicolor/index.theme $out/share/icons/hicolor/
      for size in 16 24 32 48 64 128 256; do
        mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
        cp $out/opt/thorium/product_logo_256.png $out/share/icons/hicolor/''${size}x''${size}/apps/thorium-browser.png
      done
      runHook postInstall
    '';

    postFixup = ''
      wrapProgram $out/bin/thorium \
        --prefix PATH : ${lib.makeBinPath [xdg-utils gnome-settings-daemon]} \
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:$out/share" \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs} \
        --add-flags "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,UseOzonePlatform" \
        --add-flags "--ozone-platform-hint=auto" \
        --set-default CHROME_VERSION_EXTRA "Thorium AVX2"
    '';

    meta = {
      description = "Thorium Browser (Chromium fork)";
      homepage = "https://github.com/Alex313031/Thorium";
      license = lib.licenses.bsd3;
      platforms = ["x86_64-linux"];
      maintainers = ["Hibiki"];
      mainProgram = "thorium";
    };
  })
