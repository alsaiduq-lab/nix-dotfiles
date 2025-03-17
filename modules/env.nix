{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.shellInit = ''
    if [ -d $HOME/.cargo/bin ]; then
      export PATH=$PATH:$HOME/.cargo/bin
    fi
  '';

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERM = "ghostty";
    GTK_THEME = lib.mkDefault "Adwaita:dark";
    CC = "${pkgs.gcc}/bin/gcc";
    PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" [
      pkgs.openssl.dev
      pkgs.libxml2.dev
      pkgs.zlib.dev
    ];
  };

  environment.pathsToLink = [
    "/share/fish"
    "/bin"
  ];

  # Enable direnv with nix integration
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
