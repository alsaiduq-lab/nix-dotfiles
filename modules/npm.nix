{
  config,
  pkgs,
  lib,
  ...
}: let
  npmConf = pkgs.writeText "npmrc" ''
    prefix=${config.environment.variables.NPM_CONFIG_PREFIX}
    cache=$HOME/.npm
    init-module=$HOME/.npm-init.js
    node-linker=hoisted
  '';
in {
  options.npm = {
    enable = lib.mkEnableOption "System NPM Environment";
  };
  config = lib.mkIf config.npm.enable {
    environment.systemPackages = with pkgs; [
      nodejs
      nodePackages.npm
    ];
    environment.variables = {
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
      PATH = ["$HOME/.npm-global/bin"];
      NPM_CONFIG_USERCONFIG = "${npmConf}";
    };
    system.userActivationScripts.setupNpm = ''
      mkdir -p $HOME/.npm-global/bin
      mkdir -p $HOME/.npm
      if [ ! -f "$HOME/.npmrc" ]; then
        cp ${npmConf} $HOME/.npmrc
      fi
      if [ -d "$HOME/.npm-global" ]; then
        chmod -R +rw $HOME/.npm-global
      fi
    '';
  };
}
