{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    minijinja-cli
  ];
}
