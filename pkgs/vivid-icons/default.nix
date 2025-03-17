{
  lib,
  stdenv,
  fetchFromGitHub,
  hicolor-icon-theme,
}:
stdenv.mkDerivation rec {
  pname = "vivid-icons";
  version = "2025-03-16";
  src = fetchFromGitHub {
    owner = "L4ki";
    repo = "Vivid-Plasma-Themes";
    rev = "fe8b8f1bdd3784dc838c125bb9e1b2d713f40e67";
    sha256 = "1rcphy08r6337gbp98nz00mj780jn9kwm40ngd9pxnlvwp2n8mjj";
  };
  buildInputs = [hicolor-icon-theme];
  installPhase = ''
        mkdir -p $out/share/icons
        cp -r "Vivid Icons Themes/"* $out/share/icons/
        for theme in $out/share/icons/*; do
          if [ -d "$theme" ]; then
            echo "Processing theme: $theme"
            cat > "$theme/index.theme" <<EOF
    [Icon Theme]
    Name=$(basename "$theme")
    Comment=$(basename "$theme") icons
    Inherits=hicolor
    Directories=8x8,16x16,22x22
    [8x8]
    Size=8
    Context=Emblems
    Type=Fixed
    [16x16]
    Size=16
    Context=Actions
    Type=Fixed
    [22x22]
    Size=22
    Context=Actions
    Type=Fixed
    EOF
          fi
        done
  '';
  meta = with lib; {
    description = "Vivid Icons Theme";
    homepage = "https://github.com/L4ki/Vivid-Plasma-Themes";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = ["Cobray"];
  };
}
