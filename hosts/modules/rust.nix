{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    cargo-edit
    cargo-watch
    cargo-outdated
    cargo-audit
    minijinja-cli
  ];
}
