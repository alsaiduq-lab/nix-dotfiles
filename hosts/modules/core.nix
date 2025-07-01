{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    tree
    fd
    jq
    gawk
    psmisc
    unzip
    bash
    maim
    wrk
    bitwarden
    hashcat
    cachix
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
    nix-prefetch-git
  ];
}
