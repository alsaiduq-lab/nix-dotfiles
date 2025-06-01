{
  pkgs,
  lib,
  ...
}: {
  binary-clock-font = pkgs.stden.mkDerivation {
    pname = "binary-clock-font";
    version = "1.0.0";
    src = pkgs.fetchurl {
      url = "https://github.com/jamessouth/polybar-binary-clock-fonts/raw/master/BinaryClockBoldMono.ttf";
      sha256 = "0vxy23zr8r8faa5s7vy5bf8z2q7my39ghmd9ilk7aww9wqsrsjqx";
    };
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp $src $out/share/fonts/truetype/BinaryClockBoldMono.ttf
    '';
    meta = with lib; {
      description = "A monospaced bold font for binary clocks";
      homepage = "https://github.com/jamessouth/polybar-binary-clock-fonts";
      license = licenses.ofl;
      platforms = platforms.all;
      maintainers = with maintainers; [cobray];
    };
  };
}
