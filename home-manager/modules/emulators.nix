{pkgs, ...}: {
  home.packages = with pkgs; [
    desmume
    rpcs3
    ppsspp
    mgba
    dolphin-emu
    vita3k
    ryubing
  ];
}
