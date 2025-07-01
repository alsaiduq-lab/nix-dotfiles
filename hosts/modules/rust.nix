{pkgs, ...}: let
  rustToolchain = pkgs.symlinkJoin {
    name = "rust-toolchain";
    paths = with pkgs; [rustc cargo rustfmt clippy];
  };
in {
  environment.systemPackages = with pkgs; [
    rustToolchain
    rust-analyzer
    cargo-edit
    cargo-watch
    cargo-outdated
    cargo-audit
    minijinja-cli
  ];
}
