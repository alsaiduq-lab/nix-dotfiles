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
        *) if [ -d "$HOME/.npm-global/bin" ]; then
             PATH="$HOME/.npm-global/bin:$PATH"
             export PATH
           fi ;;
      esac
    '';

    environment.etc."fish/conf.d/50-npm-global.fish".text = ''
      if test -d "$HOME/.npm-global/bin"
        if not contains -- "$HOME/.npm-global/bin" $PATH
          set -gx PATH "$HOME/.npm-global/bin" $PATH
        end
      end
    '';
  };
}

