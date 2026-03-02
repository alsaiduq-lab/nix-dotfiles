{pkgs, ...}: {
  home.packages = with pkgs; [
    desmume
    rpcs3
    input-remapper
  ];
}
