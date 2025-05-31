{pkgs, ...}: {
  home.packages = with pkgs; [
    fish-rust
    fzf
    bat
    eza
    fd
    ugrep
  ];
}
