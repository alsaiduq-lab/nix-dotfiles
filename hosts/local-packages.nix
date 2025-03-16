{ config, pkgs, lib, ... }:

let
  customPkgs = import ../pkgs { inherit pkgs lib; };
in
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Applications
    brave
    ghostty
    vesktop
    neovim
    git
    fastfetch
    # Development tools
    nodejs
    wget
    curl
    tree
    gnumake
    gcc
    socat
    gdb
    binutils
    cmake
    ninja
    pkg-config
    autoconf
    automake
    libtool
    gawk
    obs-studio
    lazygit
    # Java ecosystem
    jdk17
    maven
    gradle
    visualvm
    jdt-language-server
    (python310.withPackages (ps: with ps; [
      virtualenv
      ipython
      i3ipc
      xlib
      six
      psutil
      pynvml
      pyqtgraph
      pyqt6
      numpy
      pandas
      matplotlib
      scipy
      requests
      click
      typer
      rich
      pyyaml
      pytz
      onnxruntime
      opencv4
      pillow
      customPkgs.python-rembg
    ]))
    uv
    ruff
    black
    mypy
    htop
    btop
    nvtopPackages.full
    ripgrep
    fd
    fzf
    jq
    bash
    go
    sqls
    deno
    redis
    cloudflared
    # Rust ecosystem
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
    yt-dlp
    nmap
    psmisc
    ugrep
    unzip
    starship
    flameshot
  ];
}
