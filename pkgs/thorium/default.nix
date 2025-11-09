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
    mkdir -p $out/{opt/thorium,bin,share/{applications,icons/hicolor/256x256/apps}}
    cp -r $(find opt -type d -name thorium | head -1)/* $out/opt/thorium/
    rm -f $out/opt/thorium/libqt{5,6}_shim.so
    ln -sf $out/opt/thorium/thorium $out/bin/thorium
    ln -sf $out/bin/thorium $out/bin/thorium-browser
    if [ -f usr/share/applications/thorium*.desktop ]; then
      sed -E \
        -e "s|^Exec=.*|Exec=$out/bin/thorium %U|" \
        -e "s|^Icon=.*|Icon=thorium|" \
        usr/share/applications/thorium*.desktop > $out/share/applications/thorium.desktop
    fi
    [ -d usr/share/icons ] && cp -r usr/share/icons/* $out/share/icons/ || true
    [ -d usr/share/pixmaps ] && cp -r usr/share/pixmaps/* $out/share/icons/ || true
    if [ -f $out/opt/thorium/product_logo_256.png ]; then
      cp $out/opt/thorium/product_logo_256.png $out/share/icons/hicolor/256x256/apps/thorium.png
    elif [ -f $out/opt/thorium/thorium.png ]; then
      cp $out/opt/thorium/thorium.png $out/share/icons/hicolor/256x256/apps/thorium.png
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
