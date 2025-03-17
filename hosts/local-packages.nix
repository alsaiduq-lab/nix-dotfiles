{
  config,
  pkgs,
  lib,
  ...
}: let
  customPkgs = import ../pkgs {inherit pkgs lib;};
in {
  environment.systemPackages = with pkgs; [
    # Applications
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
    gnused
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
    jdk17
    maven
    gradle
    visualvm
    jdt-language-server
    (python310.withPackages (ps:
      with ps;
        [
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
        ]
        ++ [customPkgs.python-rembg]))
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
    customPkgs.fish-rust
    go
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
  ];
}
