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
      rev = "99e2cab828459373bc7524690668fdd209b3f517";
    };
    recursive = true;
  };
}
