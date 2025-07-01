{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    linuxHeaders
    freetype.dev
    pixman
    mesa
    libglvnd
    dbus.dev
    openssl
    openssl.dev
    libxml2
    zlib
    zlib.dev
    texlive.combined.scheme-full
    poppler_utils
  ];
}
