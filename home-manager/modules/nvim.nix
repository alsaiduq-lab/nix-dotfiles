{
  config,
  pkgs,
  lib,
  ...
}: let
  gitDir = "${pkgs.git}/bin/git";
  nvim = "${config.home.homeDirectory}/.config/nvim";
in {
  programs.neovim = {
    enable = true;
    extraPython3Packages = ps: [ps.pynvim];
  };

  home.packages = with pkgs; [
    git
    luajit
    luaPackages.luarocks
    tree-sitter
  ];

  home.sessionPath = ["$HOME/.local/share/nvim/mason/bin"];

  home.activation.nvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "${nvim}/.git" ]; then
      ${gitDir} clone --depth 1 \
        https://github.com/alsaiduq-lab/nvim-dotfiles.git "${nvim}"
      echo "Neovim config at ${nvim} was installed"
    else
      if ${gitDir} -C "${nvim}" pull --ff-only origin master \
           | grep -q 'Already up to date.'; then
        echo "Neovim config at ${nvim} is unchanged"
      else
        echo "Neovim config at ${nvim} was updated"
      fi
    fi
  '';
}
