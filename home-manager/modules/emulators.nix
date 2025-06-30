{pkgs, ...}: {
  home.packages = with pkgs; [
    desmume
    duckstation
    ryujinx
    retroarch
    mednafen
    waydroid
    shadps4
    rpcs3_latest
  ];
}
