{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.nvim-dots.packages.${pkgs.stdenv.hostPlatform.system}.full
  ];
}
