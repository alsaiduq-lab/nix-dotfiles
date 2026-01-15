{
  pkgs,
  lib,
  ...
}:
pkgs.stdenv.mkDerivation {
  pname = "clear-sans";
  version = "1.0";
  src = pkgs.fetchFromGitHub {
    owner = "intel";
    repo = "clear-sans";
    rev = "main";
    sha256 = "sha256-+xdetdE3Z4NlrWiEYCUO5bmf06g/+p5blkkNk+XcruQ=";
  };
  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp TTF/*.ttf $out/share/fonts/truetype/
  '';
  meta = with lib; {
    description = "Clear Sans font";
    homepage = "https://github.com/intel/clear-sans";
    license = licenses.asl20;
    maintainers = [cobray];
    platforms = platforms.all;
  };
}
