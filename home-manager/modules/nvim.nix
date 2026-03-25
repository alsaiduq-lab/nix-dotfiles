{pkgs, ...}: {
  programs.neovim.enable = true;
  home.packages = with pkgs; [
    luajit
    luaPackages.luarocks
    tree-sitter
  ];
}
