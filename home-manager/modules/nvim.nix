{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.neovim.enable = true;
  home.packages = with pkgs; [
    git
    luajit
    luaPackages.luarocks
    tree-sitter
  ];
}
