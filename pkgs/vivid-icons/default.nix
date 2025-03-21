{
  lib,
  stdenv,
  fetchFromGitHub,
  hicolor-icon-theme,
}:
stdenv.mkDerivation rec {
  pname = "vivid-icons";
  version = "unstable-${builtins.substring 0 7 "fe8b8f1bdd3784dc838c125bb9e1b2d713f40e67"}";

  src = fetchFromGitHub {
    owner = "L4ki";
    repo = "Vivid-Plasma-Themes";
    rev = "fe8b8f1bdd3784dc838c125bb9e1b2d713f40e67";
    sha256 ="X6NPEIhjYzf2mYOYnDADJ4A5nJ6T4HTRnF5Y9vKNIrw=";
  };

  buildInputs = [ hicolor-icon-theme ];

  installPhase = ''
    mkdir -p $out/share/icons

    for dir in Vivid-Icons-*; do
      if [ -d "$dir" ]; then
        theme_name=$(basename "$dir")
        dest_dir="$out/share/icons/$theme_name"
        cp -r "$dir" "$dest_dir"

        echo "[Icon Theme]" > "$dest_dir/index.theme"
        echo "Name=$theme_name" >> "$dest_dir/index.theme"
        echo "Comment=$theme_name icons" >> "$dest_dir/index.theme"
        echo "Inherits=hicolor" >> "$dest_dir/index.theme"
        directories=""
        for size_dir in "$dest_dir"/*; do
          if [ -d "$size_dir" ]; then
            size=$(basename "$size_dir")
            if [[ "$size" =~ ^[0-9]+x[0-9]+$ ]]; then
              directories="$directories''${directories:+,}$size"
              echo "[$size]" >> "$dest_dir/index.theme"
              echo "Size=''${size%%x*}" >> "$dest_dir/index.theme"
              echo "Context=Actions" >> "$dest_dir/index.theme"
              echo "Type=Fixed" >> "$dest_dir/index.theme"
            fi
          fi
        done
        echo "Directories=$directories" >> "$dest_dir/index.theme"
      fi
    done

    echo "Installed themes:"
    ls -la $out/share/icons/
  '';

  meta = with lib; {
    description = "Vivid Icons Theme";
    homepage = "https://github.com/L4ki/Vivid-Plasma-Themes";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ "Cobray" ];
  };
}
