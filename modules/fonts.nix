{ config, pkgs, lib, ... }:

{
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "0xProto" "FiraCode" "JetBrainsMono" "Hack" "Noto" "NerdFontsSymbolsOnly" ]; })
      ipafont
      kochi-substitute
      # Custom BinaryClock font
      (stdenv.mkDerivation {
        name = "binary-clock-font";
        src = fetchurl {
          url = "https://github.com/jamessouth/polybar-binary-clock-fonts/raw/master/BinaryClockBoldMono.ttf";
          sha256 = "0vxy23zr8r8faa5s7vy5bf8z2q7my39ghmd9ilk7aww9wqsrsjqx";
        };
        dontUnpack = true;
        installPhase = ''
          mkdir -p $out/share/fonts/truetype
          cp $src $out/share/fonts/truetype/BinaryClockBoldMono.ttf
        '';
      })
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrains Mono" "Noto Sans Mono CJK JP" ];
        sansSerif = [ "Noto Sans" "Noto Sans CJK JP" ];
        serif = [ "Noto Serif" "Noto Serif CJK JP" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
