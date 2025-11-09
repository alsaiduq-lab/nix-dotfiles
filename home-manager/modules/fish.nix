{pkgs, ...}: {
  home.packages = with pkgs; [
    fish
    fzf
    ripgrep
    bat
    eza
    ugrep
    yazi
    chafa
    btop
    nvtopPackages.full
  ];
}
