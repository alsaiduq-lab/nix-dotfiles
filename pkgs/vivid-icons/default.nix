{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "vivid-icons";
  version = "2025-03-16";

  src = fetchFromGitHub {
    owner = "L4ki";
    repo = "Vivid-Plasma-Themes";
    rev = "a7fe21ff30e9efbc47043bf004f99ed06c3877f4";
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
