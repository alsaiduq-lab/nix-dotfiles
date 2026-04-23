{pkgs, ...}: {
  home.packages = with pkgs; [
    desmume
    rpcs3
    ppsspp
    mgba
    dolphin-emu
    input-remapper
    vita3k
    ryubing
  ];
}
