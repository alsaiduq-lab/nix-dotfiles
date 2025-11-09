{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  dpkg,
  gnutar,
  xdg-utils,
  nss,
  nspr,
  glib,
  gtk3,
  at-spi2-atk,
  at-spi2-core,
  dbus,
  libdrm,
  mesa,
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
}:
stdenvNoCC.mkDerivation rec {
  pname = "thorium";
  version = "130.0.6723.174";

  src = fetchurl {
    url = "https://github.com/Alex313031/Thorium/releases/download/M${version}/thorium-browser_${version}_AVX2.deb";
    sha256 = "sha256-TeDwx7Bqy0NSaNBMuzCf4O+rgWjB/tmIvDgJQnGVSGY=";
  };

  nativeBuildInputs = [autoPatchelfHook makeWrapper dpkg gnutar];
  buildInputs = [
    nss
    nspr
    glib
    gtk3
    at-spi2-atk
    at-spi2-core
    dbus
    libdrm
    mesa
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

  unpackPhase = ''
    ar x "$src"
    tar --no-same-owner --no-same-permissions -xf data.tar.*
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
        usr/share/applications/thorium-browser.desktop > $out/share/applications/thorium.desktop
    fi
    if [ -d usr/share/icons ]; then
      cp -r usr/share/icons $out/share/
    fi
    if [ ! -d $out/share/icons/hicolor ]; then
      mkdir -p $out/share/icons/hicolor/{48x48,128x128,256x256}/apps
      if [ -f $out/opt/thorium/product_logo_256.png ]; then
        cp $out/opt/thorium/product_logo_256.png $out/share/icons/hicolor/256x256/apps/thorium-browser.png
      elif [ -f $out/opt/thorium/product_logo_128.png ]; then
        cp $out/opt/thorium/product_logo_128.png $out/share/icons/hicolor/128x128/apps/thorium-browser.png
      elif [ -f $out/opt/thorium/thorium.png ]; then
        cp $out/opt/thorium/thorium.png $out/share/icons/hicolor/256x256/apps/thorium-browser.png
      fi
    fi
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/thorium \
      --prefix PATH : ${lib.makeBinPath [xdg-utils gnome-settings-daemon]} \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:$out/share" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
      --add-flags "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,UseOzonePlatform" \
      --add-flags "--ozone-platform-hint=auto" \
      --set-default CHROME_VERSION_EXTRA "Thorium AVX2"
  '';

  meta = {
    description = "Thorium Browser (Chromium fork)";
    homepage = "https://github.com/Alex313031/Thorium";
    license = lib.licenses.bsd3;
    platforms = ["x86_64-linux"];
    maintainers = ["Cobray"];
    mainProgram = "thorium";
  };
}
