{ config, pkgs, lib, ... }:

{
  environment.shellInit = ''
    if [ -d $HOME/.cargo/bin ]; then
      export PATH=$PATH:$HOME/.cargo/bin
    fi
    if [ -f /run/current-system/sw/bin/python3 ]; then
      alias python3=/run/current-system/sw/bin/python3
      alias python=/run/current-system/sw/bin/python3
    fi
  '';

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERM = "xterm-256color";
    GTK_THEME = "Adwaita:dark";
    CC = "${pkgs.gcc}/bin/gcc";
    PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" [
      pkgs.openssl.dev
      pkgs.libxml2.dev
      pkgs.zlib.dev
    ];
  };

  environment.pathsToLink = [
    "/share/fish"
    "/lib/python3.10/site-packages"
    "/lib/python3.11/site-packages"
    "/bin"
  ];

  environment.systemPackages = with pkgs; [
    neovim
    tmux
    htop
    btop
    bat
    ripgrep
    fd
    yt-dlp
    eza
    jq
    fzf
    starship
    yazi
    fastfetch
    # Core utilities
    wget
    libnotify
    curl
    git
    file
    which
    psmisc
  ];

  # Enable direnv with nix integration
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
