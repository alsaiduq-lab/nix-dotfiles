{
  pkgs,
  lib,
  ...
}: let
  customPkgs = import ../pkgs {inherit pkgs lib;};
in {
  imports = [
    ../modules/python.nix
  ];
  python.enable = true;
  environment.systemPackages = with pkgs; [
    (python311.withPackages (pyPkgs:
      with pyPkgs; [
        requests
        pip
        virtualenv
        ipython
      ]))
    python3Packages.pip
    black
    brave # TODO: make a module to save browser stuff
    vesktop
    git
    nodejs
    wget
    curl
    tree
    gnumake
    gcc
    socat
    ffmpeg
    gnused
    gdb
    libstdcxx5
    stdenv.cc.cc.lib
    nix-prefetch-git
    binutils
    hashcat
    cmake
    ninja
    pkg-config
    autoconf
    automake
    libtool
    gawk
    obs-studio
    lazygit
    lazydocker
    jdk17
    bun
    maven
    gradle
    visualvm
    jdt-language-server
    htop
    btop
    nvtopPackages.full
    ripgrep
    fd
    fzf
    jq
    bash
    customPkgs.fish-rust
    go
    ollama
    sqls
    deno
    redis
    cloudflared
    rustup
    cargo-edit
    cargo-watch
    cargo-outdated
    cargo-audit
    openssl
    openssl.dev
    pkg-config
    libxml2
    zlib
    ghc
    cabal-install
    stack
    haskell-language-server
    postgresql
    sqlite
    spotify
    git-lfs
    gitAndTools.gh
    gitAndTools.diff-so-fancy
    ani-cli
    yt-dlp
    nmap
    psmisc
    ugrep
    unzip
    starship
    flameshot
    yarn
    mpv
    httpie
    wrk
    nodePackages.pnpm
    zlib.dev
  ];
  environment.shellAliases = {
    python = "python3.11";
  };
}
