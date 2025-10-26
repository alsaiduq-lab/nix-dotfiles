{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    busybox # in case im missing something random
    fd
    jq
    wrk
    bitwarden
    hashcat
    cachix
    gcc14
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
    nix-prefetch-git
    icu
    libclang
    argc
    clang
    openssl
    pinix
  ];
}
