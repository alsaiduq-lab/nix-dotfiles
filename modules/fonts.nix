{pkgs, ...}: let
  clear-sans = pkgs.stdenv.mkDerivation {
    name = "clear-sans";
    src = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/resir014/Clear-Sans-Webfont/97eec13/fonts/TTF/ClearSans-Regular.ttf";
      sha256 = "0vzhy3l056gj5vkcs1kglr4mr0546fq093v78i4ri8xni7w1m0dv";
    };
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp $src $out/share/fonts/truetype/ClearSans-Regular.ttf
    '';
  };
in {
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      nerd-fonts._0xproto
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.noto
      nerd-fonts.symbols-only
      ipafont
      kochi-substitute
      clear-sans
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
        monospace = ["0xProto Nerd Font" "Noto Sans Mono CJK JP"];
        sansSerif = ["Clear Sans" "Noto Sans CJK JP"];
        serif = ["Noto Serif" "Noto Serif CJK JP"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
