{
  pkgs,
  lib,
  wine-cachyos,
}:
pkgs.stdenv.mkDerivation {
  pname = "wine-cachyos";
  version = "10.18";
  src = wine-cachyos;
  nativeBuildInputs = with pkgs; [
    autoconf
    automake
    bison
    flex
    fontforge
    gettext
    makeWrapper
    perl
    pkg-config
    python3
    wayland-scanner
  ];

  buildInputs = with pkgs; [
    SDL2
    alsa-lib
    cups
    dbus
    fontconfig
    freetype
    gnutls
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libGL
    libdrm
    libpulseaudio
    libunwind
    libusb1
    libva
    mesa
    ncurses
    openldap
    pcre2
    samba
    udev
    vulkan-headers
    vulkan-loader
    wayland
    wayland-protocols
    libxkbcommon
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    xorg.libXxf86vm
  ];

  patches = [];

  postPatch = ''
    sed -i '/BCRYPT_ECDH_P384_ALGORITHM/a #define BCRYPT_ECDH_P521_ALGORITHM  L"ECDH_P521"' include/bcrypt.h
  '';

  postUnpack = ''
    export HOME=$TMPDIR
    cd $sourceRoot
    patchShebangs tools dlls/winevulkan
    ./autogen.sh
    cd ..
  '';

  configureFlags = [
    "--disable-tests"
    "--with-x"
    "--with-gstreamer"
    "--with-wayland"
    "--with-vulkan"
    "--enable-win64"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Wine with CachyOS optimizations";
    homepage = "https://github.com/CachyOS/wine-cachyos";
    license = licenses.lgpl21Plus;
    platforms = ["x86_64-linux"];
    maintainers = ["Cobray"];
  };
}
