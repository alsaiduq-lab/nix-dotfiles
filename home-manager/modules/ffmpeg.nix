{pkgs, ...}: let
  x11ffmpeg = pkgs.ffmpeg-full.overrideAttrs (old: {
    buildInputs =
      (old.buildInputs or [])
      ++ [
        pkgs.xorg.libxcb
        pkgs.xorg.libX11
        pkgs.xorg.xcbutil
        pkgs.xorg.xcbutilimage
        pkgs.xorg.xcbutilkeysyms
        pkgs.xorg.xcbutilwm
      ];
    configureFlags =
      (old.configureFlags or [])
      ++ [
        "--enable-libxcb"
        "--enable-libxcb-shm"
        "--enable-libxcb-xfixes"
      ];
  });
in {
  home.packages = [
    x11ffmpeg
  ];
}
