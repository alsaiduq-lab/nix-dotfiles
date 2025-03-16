{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "vivid-icons";
  version = "2025-03-16";

  src = fetchFromGitHub {
    owner = "L4ki";
    repo = "Vivid-Plasma-Themes";
    rev = "fe8b8f1bdd3784dc838c125bb9e1b2d713f40e67";
    sha256 = "1rcphy08r6337gbp98nz00mj780jn9kwm40ngd9pxnlvwp2n8mjj";
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
    maintainers = [ "Cobray" ];
  };
}
