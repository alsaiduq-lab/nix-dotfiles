{
  config,
  lib,
  pkgs,
  nvimDots,
  hyprlanddots,
  ...
}: {
  imports = [
    ./modules/fish.nix
    ./modules/lazygit.nix
    ./modules/nvim.nix
    ./modules/starship.nix
    ./modules/zellij.nix
  ];
  home = {
    username = "alteur";
    homeDirectory = "/home/alteur";
    stateVersion = "25.11";
    activation.ServerInit = lib.hm.dag.entryAfter ["linkGeneration"] ''
      set -euo pipefail
      umask 022
      repo=${lib.escapeShellArg hyprlanddots}
      nvimrepo=${lib.escapeShellArg nvimDots}
      mkdir -p "${config.xdg.configHome}"
      copy_dir() {
        src="$1"; dest="$2"; skip="''${3:-true}"
        [ -d "$src" ] || return 0
        [ "$skip" = "true" ] && [ -e "$dest" ] && return 0
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
      copy_dir "$nvimrepo"        "${config.xdg.configHome}/nvim"
      if [ -f "$repo/starship.toml" ] && [ ! -e "${config.xdg.configHome}/starship.toml" ]; then
        install -Dm0644 "$repo/starship.toml" "${config.xdg.configHome}/starship.toml"
      fi
    '';
  };
  programs.home-manager.enable = true;
  #home.packages = with pkgs; [
  #];
}
