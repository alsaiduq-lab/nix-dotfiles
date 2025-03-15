{ config, pkgs, lib, ... }:
let
  python-rembg = pkgs.python310.pkgs.buildPythonPackage rec {
    pname = "rembg";
    version = "2.0.50";
    src = pkgs.python310.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "0dgq291bj4w6jkcyz7lvp1vba2nczfnmxa2acl2sqib5p8cpzjvc";
    };
    propagatedBuildInputs = with pkgs.python310.pkgs; [
      numpy
      pillow
      onnxruntime
      opencv4
      requests
    ];
    doCheck = false;
    meta = with lib; {
      description = "Tool to remove images background";
      homepage = "https://github.com/danielgatis/rembg";
      license = licenses.mit;
    };
  };
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
      psutil
      click
      typer
      rich
      pyyaml
      jq
      pytz
      onnxruntime
      opencv4
      pillow
      python-rembg  # custom rembg package
    ]))
    # ML-oriented
    (python311.withPackages (ps: with ps; [
      virtualenv
      ipython
      jupyter
      jupyterlab
      numpy
      pandas
      matplotlib
      scipy
      scikit-learn
      seaborn
      plotly
      pytorch-bin
      torchvision-bin
      torchaudio-bin
      tensorboard
      transformers
      huggingface-hub
      datasets
      nltk
      spacy
      pillow
      opencv4
      xgboost
      lightgbm
      optuna
      joblib
      requests
      streamlit
      gradio
      polars
      duckdb
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
    nmap
    psmisc
    ugrep
    unzip
    starship
    flameshot
  ];
}
