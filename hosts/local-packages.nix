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
    brave # TODO: make a module to save browser stuff
    vesktop
    obs-studio
    spotify
    flameshot
    mpv
    udiskie
    git
    git-lfs
    gitAndTools.gh
    gitAndTools.diff-so-fancy
    lazygit
    lazydocker
    mercurial
    nodejs
    nodePackages.pnpm
    nodePackages.typescript
    yarn
    bun
    deno
    go
    go-tools
    gopls
    rustc
    rustup
    cargo-edit
    cargo-watch
    cargo-outdated
    cargo-audit
    rust-analyzer
    python3Packages.debugpy
    customPkgs.python-ngx-lsp
    gcc
    stdenv.cc.cc.lib
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
    ghc
    cabal-install
    stack
    haskell-language-server
    jdk17
    maven
    gradle
    visualvm
    jdt-language-server
    clang-tools
    vscode-langservers-extracted
    nodePackages.eslint
    lua-language-server
    marksman
    nil
    ruff
    taplo
    yaml-language-server
    alejandra
    nodePackages.prettier
    stylua
    shfmt
    nodePackages.sql-formatter
    yamlfmt
    luaPackages.luacheck
    nodePackages.markdownlint-cli
    nodePackages.stylelint
    nodePackages.htmlhint
    yamllint
    nodePackages.jsonlint
    hadolint
    shellcheck
    cppcheck
    rubocop
    phpPackages.php-codesniffer
    phpPackages.phpstan
    checkstyle
    tflint
    sqlfluff
    wget
    curl
    tree
    socat
    gnused
    gawk
    nmap
    psmisc
    ugrep
    unzip
    starship
    htop
    btop
    nvtopPackages.full
    fd
    fzf
    jq
    bash
    customPkgs.fish-rust
    xorg.xdpyinfo
    slop
    dunst
    pulseaudio
    ani-cli
    yt-dlp
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
    ollama
    tree-sitter
    luajitPackages.jsregexp
  ];
}
