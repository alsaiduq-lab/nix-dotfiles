{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    busybox # in case im missing something random
    unzip
    jq
    wrk
    gcc15
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
    icu
    argc
    clang
    openssl
    cairo
    cabextract
    xdg-utils
    cacert
  ];
}
