{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    fish-rust
    starship
    fzf
    bat
    eza
    fd
    ripgrep
  ];
}
