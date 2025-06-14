# TODO: cleanout and repopulate individual packages better
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    obs-studio
    spotify
    flameshot
    mpv
    linuxHeaders
    appimage-run
    freetype.dev
    zed-editor
    pixman
    udiskie
    maim
    mercurial
    obsidian
    go
    go-tools
    gopls
    gcc
    gnumake
    cmake
    ninja
    binutils
    gdb
    pkg-config
    autoconf
    automake
    libtool
    nasm
    elixir
    swift
    zig
    dbus.dev
    pkg-config
    ghc
    cacert
    cabal-install
    stack
    jdk17
    maven
    gradle
    visualvm
    wget
    curl
    tree
    mesa
    libglvnd
    socat
    gawk
    nmap
    psmisc
    unzip
    fd
    jq
    bash
    slop
    yt-dlp # might remove for source built version
    httpie
    wrk
    cloudflared
    hashcat
    nix-prefetch-git
    openssl
    openssl.dev
    libxml2
    zlib
    zlib.dev
    postgresql
    sqlite
    redis
    sqls
    luajitPackages.jsregexp
    cachix
    texlive.combined.scheme-full
    imagemagick
    poppler_utils
    ghostscript
  ];
}
