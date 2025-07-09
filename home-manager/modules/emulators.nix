{pkgs, ...}: {
  home.packages = with pkgs; [
    desmume
    ryujinx
    retroarch
    waydroid
    rpcs3
  ];
}
