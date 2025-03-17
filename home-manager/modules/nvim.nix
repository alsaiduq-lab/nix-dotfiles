{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    neovim
    ripgrep
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
    LUA_PATH = "${pkgs.luajit}/share/lua/5.1/?.lua;;";
    LUA_CPATH = "${pkgs.luajit}/lib/lua/5.1/?.so;;";
  };

  home.sessionPath = [
    "$HOME/.local/share/nvim/mason/bin"
  ];

  xdg.configFile."nvim" =
    if !builtins.pathExists "${config.home.homeDirectory}/.config/nvim"
    then {
      source = builtins.fetchGit {
        url = "https://github.com/alsaiduq-lab/nvim-dotfiles.git";
        ref = "master";
        rev = "71155b4a4b63d9974f1bc3b66303d6f7e5e06871";
      };
      recursive = true;
    }
    else null;
}
