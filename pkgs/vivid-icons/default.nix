{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "vivid-icons";
  version = "2025-03-16";

  src = fetchFromGitHub {
    owner = "L4ki";
    repo = "Vivid-Plasma-Themes";
    rev = "a7fe21fb5c51e1f66ef13c899e0e9beabd03c9f8";
    sha256 = "sha256-UhDttFWQMkiG3Ls4UdI3jJt17PfXzfzGR4d9vS2I/1Q=";
  };

  installPhase = ''
    mkdir -p $out/share/icons
    cp -r "Vivid Icons Themes/"* $out/share/icons/
  '';

  meta = with lib; {
    description = "Vivid Icons";
    homepage = "https://github.com/L4ki/Vivid-Plasma-Themes";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [];
  };
}
