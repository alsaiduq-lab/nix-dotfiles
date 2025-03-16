{ lib, stdenv, fetchFromGitHub, gtk-engine-murrine, gtk_engines }:

stdenv.mkDerivation {
  pname = "tokyo-night-gtk";
  version = "2025-03-16";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Tokyo-Night-GTK-Theme";
    rev = "cf6665a3115508a06cea28e8a23b9c90b8ef08c1";
    sha256 = "sha256-/VhwciY8iyxWOJI3lbbNRkF86rVFrjViZ5YCxHR+mFw=";
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
