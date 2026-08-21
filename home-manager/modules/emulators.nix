{pkgs, ...}: {
  home.packages = with pkgs; [
    melonds
    rpcs3
    ppsspp
    mgba
    dolphin-emu
    vita3k
    ryubing
  ];
}
