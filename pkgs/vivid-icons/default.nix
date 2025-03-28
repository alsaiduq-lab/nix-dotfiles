{
  lib,
  stdenv,
  fetchFromGitHub,
  hicolor-icon-theme,
  candy-icons,
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
  propagatedBuildInputs = [ hicolor-icon-theme candy-icons ];
  dontBuild = true;
  dontFixup = true;
  dontUpdateIconCache = true;
  installPhase = ''
    mkdir -p $out/share/icons
    cd "Vivid Icons Themes"
    for dir in Vivid-Dark-Icons Vivid-Glassy-Dark-Icons Vivid-Magna-Glassy-Dark-Icons; do
      if [ -d "$dir" ]; then
        dest_dir="$out/share/icons/$dir"
        mkdir -p "$dest_dir"
        cp -r "$dir"/* "$dest_dir/" || true
        mkdir -p "$dest_dir/actions/16" "$dest_dir/actions/22" "$dest_dir/actions/24" "$dest_dir/actions/32"
        mkdir -p "$dest_dir/status/16" "$dest_dir/status/22" "$dest_dir/status/24" "$dest_dir/status/32"
        essential_icons=(
          "help-about" "window-close" "gtk-apply" "go-previous" "go-next" "process-stop"
          "list-add" "list-remove" "edit-cut" "edit-copy" "edit-paste" "document-new"
          "document-open" "document-save" "document-save-as" "folder-new" "folder"
          "edit-delete" "edit-find" "edit-redo" "edit-undo" "view-refresh" "system-run"
          "dialog-ok" "dialog-cancel" "dialog-close" "dialog-error" "image-missing"
        )
        for size in 16 22 24 32; do
          mkdir -p "$dest_dir/actions/$size"
          mkdir -p "$dest_dir/status/$size"
          for icon in ''${essential_icons[@]}; do
            if [ ! -f "$dest_dir/actions/$size/$icon.svg" ] && [ ! -f "$dest_dir/actions/$size/$icon.png" ]; then
              for candy_size in $size 16 22 24 32 48 64; do
                for ext in svg png; do
                  for category in actions status apps; do
                    if [ -f "${candy-icons}/share/icons/candy-icons/$candy_size/$category/$icon.$ext" ]; then
                      ln -sf "${candy-icons}/share/icons/candy-icons/$candy_size/$category/$icon.$ext" "$dest_dir/actions/$size/$icon.$ext"
                      break 3
                    fi
                  done
                done
              done
            fi
            if [ ! -f "$dest_dir/status/$size/$icon.svg" ] && [ ! -f "$dest_dir/status/$size/$icon.png" ]; then
              for candy_size in $size 16 22 24 32 48 64; do
                for ext in svg png; do
                  for category in status actions apps; do
                    if [ -f "${candy-icons}/share/icons/candy-icons/$candy_size/$category/$icon.$ext" ]; then
                      ln -sf "${candy-icons}/share/icons/candy-icons/$candy_size/$category/$icon.$ext" "$dest_dir/status/$size/$icon.$ext"
                      break 3
                    fi
                  done
                done
              done
            fi
          done
        done
        if [ -f "$dest_dir/index.theme" ]; then
  if grep -q "^Inherits=" "$dest_dir/index.theme"; then
    sed -i 's/^Inherits=.*/Inherits=candy-icons,hicolor/' "$dest_dir/index.theme"
  else
    echo "Inherits=candy-icons,hicolor" >> "$dest_dir/index.theme"
  fi
  if grep -q "^Name=" "$dest_dir/index.theme"; then
    sed -i 's/^Name=.*/Name=Vivid-Magna-Glassy-Dark-Icons/' "$dest_dir/index.theme"
  else
    echo "Name=Vivid-Magna-Glassy-Dark-Icons" >> "$dest_dir/index.theme"
  fi
else
  cat > "$dest_dir/index.theme" << EOF
[Icon Theme]
Name=Vivid-Magna-Glassy-Dark-Icons
Comment=$dir Icon Theme
Inherits=candy-icons,hicolor
EOF
fi
        touch "$dest_dir/.icon-theme.cache"
      fi
    done
  '';
  meta = {
    description = "Vivid Icons Theme";
    homepage = "https://github.com/L4ki/Vivid-Plasma-Themes";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = [ "Cobray" ];
  };
}
