{ lib, stdenv, fetchFromGitHub, gtk-engine-murrine, gtk_engines, bash, sassc }:

stdenv.mkDerivation {
  pname = "tokyo-night-gtk";
  version = "2025-03-16";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Tokyo-Night-GTK-Theme";
    rev = "4dc45d60bf35f50ebd9ee41f16ab63783f80dd64";
    sha256 = "0c7sp9n2pc70yy9msmbmcyhqbr63v1ssnsxk6vg10zwwc3wl19h0";
  };

  nativeBuildInputs = [ bash sassc ];
  buildInputs = [ gtk-engine-murrine gtk_engines ];
  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  patchPhase = ''
    cd themes
    substituteInPlace install.sh \
      --replace-fail 'if [ "$UID" -eq "$ROOT_UID" ]; then' 'if false; then' \
      --replace-fail 'DEST_DIR="/usr/share/themes"' 'DEST_DIR="$TMPDIR/.themes"' \
      --replace-fail 'DEST_DIR="$HOME/.themes"' 'DEST_DIR="$TMPDIR/.themes"'
    substituteInPlace install.sh \
      --replace-fail 'if [[ "$(command -v gnome-shell)" ]]; then' 'if false; then' \
      --replace-fail 'if has_command xfce4-popup-whiskermen; then' 'if false; then' \
      --replace-fail 'if (pgrep xfce4-session &>/dev/null); then' 'if false; then'
  '';
  buildPhase = ''
    export HOME=$TMPDIR
    mkdir -p $TMPDIR/.themes
    bash ./install.sh -n Tokyonight
    bash ./install.sh -n Tokyonight --tweaks storm
    bash ./install.sh -n Tokyonight --tweaks storm black
    bash ./install.sh -n Tokyonight --tweaks storm black outline
    echo "Created themes:"
    ls -la $TMPDIR/.themes/
  '';

  installPhase = ''
    mkdir -p $out/share/themes
    for theme in $TMPDIR/.themes/*; do
      if [ -d "$theme" ]; then
        themeBase=$(basename "$theme")
        cp -r "$theme" "$out/share/themes/"
      fi
    done
    echo "Installed themes:"
    ls -la $out/share/themes/
  '';

  meta = with lib; {
    description = "Tokyo Night GTK Theme";
    homepage = "https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ "Cobray" ];
  };
}
