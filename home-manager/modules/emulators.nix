{pkgs, ...}: {
  home.packages = with pkgs; [
    mgba
    desmume
    duckstation
    pcsx2
    ryujinx
    mupen64plus
    dolphin-emu # might remove. causes a long time to build
    retroarch
    mednafen
    joycond
    waydroid
    shadps4
    rpcs3_latest
  ];
}
