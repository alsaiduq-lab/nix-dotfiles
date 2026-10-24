{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gcc
    rustc
    cargo
    rustfmt
    clippy
  ];
}
