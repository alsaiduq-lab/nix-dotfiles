{pkgs, ...}: {
  home.packages = with pkgs; [
    mgba
    desmume
    duckstation
    pcsx2
    rpcs3
    ryujinx
    mupen64plus
    dolphin-emulator
    retroarch
    mednafen
    joycond
  ];
}
