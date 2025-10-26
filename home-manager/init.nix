{
  lib,
  config,
  pkgs,
  hyprlanddots,
  nvimDotfiles,
  ...
}: {
  home.activation.HyprlandDots = lib.hm.dag.entryAfter ["linkGeneration"] ''
    set -euo pipefail
    umask 022
    repo=${lib.escapeShellArg hyprlanddots}
    nvimrepo=${lib.escapeShellArg nvimDotfiles}
    mkdir -p "${config.xdg.configHome}"
    copy_dir() {
      src="$1"; dest="$2"
      [ -d "$src" ] || return 0
      [ -e "$dest" ] && return 0
      mkdir -p "$dest"
      if [ -x ${pkgs.rsync}/bin/rsync ]; then
        ${pkgs.rsync}/bin/rsync -rlD \
          --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r \
          -- "$src"/ "$dest"/
      else
        cp -R -P --no-preserve=mode,ownership,timestamps -- "$src"/. "$dest"/
      fi
      chmod -R u+rwX "$dest"
    }

    copy_dir "$repo/fish"       "${config.xdg.configHome}/fish"
    copy_dir "$repo/hypr"       "${config.xdg.configHome}/hypr"
    copy_dir "$repo/cava"       "${config.xdg.configHome}/cava"
    copy_dir "$nvimrepo"        "${config.xdg.configHome}/nvim"

    if [ -f "$repo/starship.toml" ] && [ ! -e "${config.xdg.configHome}/starship.toml" ]; then
      install -Dm0644 "$repo/starship.toml" "${config.xdg.configHome}/starship.toml"
    fi
  '';
}
