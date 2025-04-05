{pkgs, ...}: {
  home.packages = with pkgs; [
    mgba
    desmume
    duckstation
    pcsx2
    ryujinx
    mupen64plus
    dolphin-emu
    retroarch
    mednafen
    joycond
  ];
}
