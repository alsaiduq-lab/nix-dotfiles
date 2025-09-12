{ config, pkgs, lib, ... }:
{
  options.npm.enable = lib.mkEnableOption "npm setup";

  config = lib.mkIf config.npm.enable {
    environment.systemPackages = with pkgs; [
      nodejs_24
      nodePackages.npm
      yarn
      bun
      nodePackages.typescript
    ];

    systemd.user.services."npm-init" = {
      wantedBy = [ "default.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        set -eu
        H="$HOME"
        mkdir -p "$H/.npm-global/bin" "$H/.npm"
        tmp="$(mktemp)"
        cat > "$tmp" <<EOF
prefix=$H/.npm-global
cache=$H/.npm
init-module=$H/.npm-init.js
EOF
        if [ ! -f "$H/.npmrc" ] || ! cmp -s "$tmp" "$H/.npmrc"; then
          mv "$tmp" "$H/.npmrc"
          chmod 600 "$H/.npmrc"
        else
          rm -f "$tmp"
        fi
      '';
    };

    environment.etc."profile.d/50-npm-global.sh".text = ''
      case ":$PATH:" in
        *:"$HOME/.npm-global/bin":*) ;;
        *) [ -d "$HOME/.npm-global/bin" ] && export PATH="$HOME/.npm-global/bin:$PATH" ;;
      esac
    '';
  };
}
