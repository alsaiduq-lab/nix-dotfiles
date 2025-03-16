{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    neovim
    ripgrep
    fd
    nodejs
    gcc
  ];

  xdg.configFile."nvim" = {
    source = builtins.fetchGit {
      url = "https://github.com/alsaiduq-lab/dotfiles.git";
      ref = "dev";
    }
    recursive = true;
  };
}
