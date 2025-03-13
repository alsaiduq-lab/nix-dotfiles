{ config, pkgs, lib, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Applications
    brave
    ghostty
    vesktop
    # Development tools
    nodejs
    tree
    gnumake
    gcc
    gdb
    binutils
    cmake
    ninja
    pkg-config
    autoconf
    automake
    libtool
    gawk
    lazygit
    # Python ecosystem
    (python310.withPackages (ps: with ps; [
      virtualenv
      ipython
      numpy
      pandas
      matplotlib
      scipy
      requests
      pytorch-bin
      torchvision-bin
      torchaudio-bin
    ]))
    (python311.withPackages (ps: with ps; [
      virtualenv
      ipython
      jupyter
      jupyterlab
      numpy
      pandas
      matplotlib
      scipy
      requests
    ]))
    uv
    ruff
    black
    # Rust ecosystem with properly configured toolchain
    rustup
    rust-analyzer
    cargo-edit
    cargo-watch
    cargo-outdated
    cargo-audit
    openssl
    openssl.dev
    pkg-config
    libxml2
    zlib
    # Haskell ecosystem
    ghc
    cabal-install
    stack
    haskell-language-server
    # Database tools
    postgresql
    sqlite
    # Version control tools
    git-lfs
    gitAndTools.gh
    gitAndTools.diff-so-fancy
    # misc
    ani-cli
    nmap
    psmisc
    ugrep
    unzip
    starship
  ];
}
