{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    neovim
    gnugrep
    fd
    fzf
    nodejs
    gcc
    git
    luajit
    luaPackages.luarocks
    nil
    lua-language-server
    curl
    unzip
    alejandra
  ];

  home.sessionVariables = {
    LUA_PATH = "${pkgs.luajit}/share/lua/5.1/?.lua;${pkgs.luajit}/share/lua/5.1/?/init.lua;;";
    LUA_CPATH = "${pkgs.luajit}/lib/lua/5.1/?.so;;";
  };

  home.sessionPath = [
    "$HOME/.local/share/nvim/mason/bin"
  ];

  xdg.configFile."nvim" = let
    nvimConfigPath = "${config.home.homeDirectory}/.config/nvim";
    # nvimDotfiles = builtins.fetchGit {
    #   url = "https://github.com/alsaiduq-lab/nvim-dotfiles.git";
    #   ref = "master";
    #   rev = "71155b4a4b63d9974f1bc3b66303d6f7e5e06871";
    # };
  in {
    source = pkgs.emptyDirectory;
    recursive = true;
    enable = !builtins.pathExists nvimConfigPath;
    onChange = ''
      echo "Neovim config at ${nvimConfigPath} was ${
        if builtins.pathExists nvimConfigPath
        then "skipped (already exists)"
        else "installed"
      }"
    '';
  };
}
