{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk-engine-murrine,
  gnome-themes-extra,
  bash,
  sassc,
}:
stdenv.mkDerivation {
  pname = "tokyo-night-gtk";
  version = "main";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Tokyonight-GTK-Theme";
    rev = "4dc45d60bf35f50ebd9ee41f16ab63783f80dd64";
    sha256 = "0c7sp9n2pc70yy9msmbmcyhqbr63v1ssnsxk6vg10zwwc3wl19h0";
  };

  nativeBuildInputs = [bash sassc];
  buildInputs = [gtk-engine-murrine gnome-themes-extra];
  propagatedUserEnvPkgs = [gtk-engine-murrine];

  buildPhase = ''
    bash ./install.sh --dest $out/share/themes -n Tokyonight
    bash ./install.sh --dest $out/share/themes -n Tokyonight --tweaks storm
    bash ./install.sh --dest $out/share/themes -n Tokyonight --tweaks storm black
    bash ./install.sh --dest $out/share/themes -n Tokyonight --tweaks storm black outline
  '';

  installPhase = "";

  meta = with lib; {
    description = "Tokyo Night GTK Theme";
    homepage = "https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = ["Cobray"];
  };
}
