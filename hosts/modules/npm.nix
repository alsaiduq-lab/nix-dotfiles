{
  config,
  pkgs,
  lib,
  ...
}: let
  npmConf = pkgs.writeText "npmrc" ''
    prefix=${"$"}HOME/.npm-global
    cache=${"$"}HOME/.npm
    init-module=${"$"}HOME/.npm-init.js
  '';
in {
  options.npm.enable = lib.mkEnableOption "system-wide npm environment";

  config = lib.mkIf config.npm.enable {
    environment.systemPackages = with pkgs; [
      nodejs_24
      nodePackages.npm
      yarn
      bun
      nodePackages.typescript
    ];

    environment.etc."npmrc".source = npmConf;

    systemd.user.services.npm-global-dir = {
      wantedBy = ["default.target"];
      script = ''
        mkdir -p $HOME/.npm-global/bin
        chmod u+rwx $HOME/.npm-global
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };

    systemd.user.services.npm-setup = {
      wantedBy = ["default.target"];
      script = ''
        if [ ! -f ~/.npmrc ]; then
          cp ${npmConf} ~/.npmrc
          chmod u+rw ~/.npmrc
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
  };
}
