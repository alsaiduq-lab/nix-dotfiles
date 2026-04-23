{pkgs, ...}: {
  home.packages = with pkgs; [
    neovim
    luajit
    luaPackages.luarocks
  ];
}
