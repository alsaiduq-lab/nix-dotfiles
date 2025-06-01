{
  pkgs,
  lib,
  ...
}: {
  clear-sans = pkgs.stdenv.mkDerivation {
    pname = "clear-sans";
    version = "1.0";
    src = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/resir014/Clear-Sans-Webfont/97eec13/fonts/TTF/ClearSans-Regular.ttf";
      sha256 = "0vzhy3l056gj5vkcs1kglr4mr0546fq093v78i4ri8xni7w1m0dv";
    };
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp $src $out/share/fonts/truetype/ClearSans-Regular.ttf
    '';
    meta = with lib; {
      description = "Clear Sans font";
      homepage = "https://github.com/intel/clear-sans";
      license = licenses.apache;
      maintainers = [cobray];
      platforms = platforms.all;
    };
  };
}
