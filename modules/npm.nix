{
  config,
  pkgs,
  lib,
  ...
}: let
  npmGlobalDir = "$HOME/.npm-global";
  npmConf = pkgs.writeText "npmrc" ''
    prefix=${npmGlobalDir}
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
      NPM_CONFIG_PREFIX = npmGlobalDir;
      PATH = ["${npmGlobalDir}/bin"];
      NPM_CONFIG_USERCONFIG = "${npmConf}";
    };
    system.userActivationScripts.setupNpm = ''
      mkdir -p ${npmGlobalDir}/bin
      mkdir -p $HOME/.npm
      if [ ! -f "$HOME/.npmrc" ]; then
        cp ${npmConf} $HOME/.npmrc
      fi
      if [ -d "${npmGlobalDir}" ]; then
        chmod -R +rw ${npmGlobalDir}
      fi
    '';
  };
}
