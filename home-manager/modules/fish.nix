{pkgs, ...}: {
  home.packages = with pkgs; [
    fish
    fzf
    bat
    eza
    fd
    ugrep
    yazi
    chafa
  ];
}
