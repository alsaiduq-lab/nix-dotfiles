{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    withPython3 = true;
    withRuby = true;
  };
  home.packages = with pkgs; [
    luajit
    luaPackages.luarocks
  ];
}
