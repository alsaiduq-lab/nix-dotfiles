{pkgs, ...}: {
  home.packages = with pkgs; [
    fish
    nix-your-shell
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
