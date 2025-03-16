{ lib, stdenv, fetchFromGitHub, gtk-engine-murrine, gtk_engines }:

stdenv.mkDerivation {
  pname = "tokyo-night-gtk";
  version = "2025-03-16";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Tokyo-Night-GTK-Theme";
    rev = "4dc45d60bf35f50ebd9ee41f16ab63783f80dd64";
    sha256 = "sha256-UhDttFWQMkiG3Ls4UdI3jJt17PfXzfzGR4d9vS2I/1Q=";
  };

  nativeBuildInputs = [ ];

  buildInputs = [
    gtk-engine-murrine
    gtk_engines
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -r themes/Tokyonight-* $out/share/themes/
  '';

  meta = with lib; {
    description = "Tokyo Night GTK Theme";
    homepage = "https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [];
  };
}
