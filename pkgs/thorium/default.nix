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
}: let
  tag = "M130.0.6723.174";
  version = "130.0.6723.174";
  variant = "SSE3";

  src = fetchurl {
    url = "https://github.com/Alex313031/Thorium/releases/download/${tag}/thorium-browser_${version}_${variant}.deb";
    sha256 = "sha256-sr8f4E329VrA1iHjF+72Db4pApTt9uDTzofr3Ak65Wo=";
  };

  libs = [
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
  ];
in
  stdenvNoCC.mkDerivation {
    pname = "thorium";
    inherit version src;

    nativeBuildInputs = [autoPatchelfHook makeWrapper dpkg gnutar];
    buildInputs = libs;

    unpackPhase = ''
      ar x "$src"
      tar --no-same-owner --no-same-permissions -xf data.tar.*
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/opt/thorium $out/bin $out/share/applications $out/share/icons

      if [ -d opt/chromium.org/thorium ]; then
        srcdir=opt/chromium.org/thorium
      else
        srcdir=opt/thorium-browser
      fi

      cp -r "$srcdir"/* $out/opt/thorium/

      rm -f $out/opt/thorium/libqt5_shim.so $out/opt/thorium/libqt6_shim.so || true

      ln -sf $out/opt/thorium/thorium $out/bin/thorium
      ln -sf $out/bin/thorium          $out/bin/thorium-browser

      desk_in=
      for f in usr/share/applications/thorium-browser.desktop usr/share/applications/thorium.desktop; do
        [ -f "$f" ] && desk_in="$f" && break
      done
      if [ -n "$desk_in" ]; then
        mkdir -p $out/share/applications
        sed -E \
          -e "s|^Exec=.*|Exec=thorium %U|" \
          -e "s|/opt/[^/]*/thorium|$out/bin/thorium|g" \
          "$desk_in" > $out/share/applications/thorium.desktop
      fi

      if [ -d usr/share/icons ]; then
        cp -r usr/share/icons/* $out/share/icons/ || true
      fi
      runHook postInstall
    '';

    postFixup = ''
      wrapProgram $out/bin/thorium \
        --prefix PATH : ${lib.makeBinPath [xdg-utils]} \
        --set-default CHROME_VERSION_EXTRA "Thorium" \
        --set LD_LIBRARY_PATH ${lib.makeLibraryPath libs}
    '';

    meta = with lib; {
      description = "Thorium Browser (Chromium fork)";
      homepage = "https://github.com/Alex313031/Thorium";
      license = licenses.unfreeRedistributable;
      platforms = ["x86_64-linux"];
      mainProgram = "thorium";
      maintainers = ["Cobray"];
    };
  }
