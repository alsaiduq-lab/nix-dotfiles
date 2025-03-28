{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "vivid-icons";
  version = "unstable-${builtins.substring 0 7 "fe8b8f1bdd3784dc838c125bb9e1b2d713f40e67"}";
  src = fetchFromGitHub {
    owner = "L4ki";
    repo = "Vivid-Plasma-Themes";
    rev = "fe8b8f1bdd3784dc838c125bb9e1b2d713f40e67";
    sha256 = "UlZkxeWb2n5TexaQymeyEqAjKwDfonTXO2OYjICHl+U=";
  };
  buildInputs = [ ];
  installPhase = ''
  echo "Source contents at root:"
  ls -la .
  mkdir -p $out/share/icons
  cd "Vivid Icons Themes"
  echo "Contents of Vivid Icons Themes:"
  ls -la .
  for dir in Vivid-Dark-Icons Vivid-Glassy-Dark-Icons Vivid-Magna-Glassy-Dark-Icons; do
    if [ -d "$dir" ]; then
      echo "Processing: $dir"
      theme_name="$dir"
      dest_dir="$out/share/icons/$theme_name"
      mkdir -p "$dest_dir"
      find "$dir" -type d -regex ".*/[0-9]+" | while read -r size_dir; do
        size=$(basename "$size_dir")
        category=$(basename "$(dirname "$size_dir")")
        target_dir="$dest_dir/''${size}x''${size}/$category"
        mkdir -p "$target_dir"
        cp -rv "$size_dir"/* "$target_dir/"
      done
      echo "[Icon Theme]" > "$dest_dir/index.theme"
      echo "Name=$theme_name" >> "$dest_dir/index.theme"
      echo "Comment=$theme_name icons" >> "$dest_dir/index.theme"
      directories=""
      for size_dir in "$dest_dir"/*; do
        if [ -d "$size_dir" ]; then
          size=$(basename "$size_dir")  # e.g., "22x22"
          if [[ "$size" =~ ^[0-9]+x[0-9]+$ ]]; then
            directories="$directories''${directories:+,}$size"
            echo "[$size]" >> "$dest_dir/index.theme"
            echo "Size=''${size%%x*}" >> "$dest_dir/index.theme"
            echo "Context=Actions" >> "$dest_dir/index.theme"
            echo "Type=Fixed" >> "$dest_dir/index.theme"
          fi
        fi
      done
      if [ -z "$directories" ]; then
        echo "No size dirs found for $theme_name, adding fallback"
        directories="scalable"
        echo "[scalable]" >> "$dest_dir/index.theme"
        echo "Size=48" >> "$dest_dir/index.theme"
        echo "Context=Actions" >> "$dest_dir/index.theme"
        echo "Type=Scalable" >> "$dest_dir/index.theme"
      fi
      echo "Directories=$directories" >> "$dest_dir/index.theme"
    else
      echo "Warning: $dir not found in Vivid Icons Themes"
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
