{
  config,
  pkgs,
  lib,
  ...
}: let
  npmGlobalDir = "~/.npm-global";
  npmConf = pkgs.writeText "npmrc" ''
    prefix=${npmGlobalDir}
    cache=~/.npm
    init-module=~/.npm-init.js
  '';
in {
  options.npm = {
    enable = lib.mkEnableOption "System NPM Environment";
  };
  config = lib.mkIf config.npm.enable {
    environment.systemPackages = with pkgs; [
      nodejs_22
      nodePackages.npm
      electron
    ];
    environment.variables = {
      NPM_CONFIG_PREFIX = npmGlobalDir;
      PATH = [
        "${pkgs.nodejs_22}/bin"
        "${npmGlobalDir}/bin"
      ];
    };
    environment.etc."npmrc".source = npmConf;
    systemd.user.services.npm-setup = {
      description = "Set up NPM user configuration";
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
