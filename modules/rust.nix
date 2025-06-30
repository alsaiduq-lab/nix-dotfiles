{
  lib,
  pkgs,
  config,
  ...
}: {
  options.rust = {
    enable = lib.mkEnableOption "System Rust Environment";
  };

  config = lib.mkIf config.rust.enable {
    environment.systemPackages = with pkgs; [
      rustup
      rust-analyzer
      clippy
      cargo-edit
      cargo-watch
      cargo-outdated
      cargo-audit
      minijinja-cli
    ];
  };
}
