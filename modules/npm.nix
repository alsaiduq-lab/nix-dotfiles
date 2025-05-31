{
  config,
  pkgs,
  lib,
  ...
}:
# TODO:bandaid fix for now
let
  npmGlobalDir = "/home/cobray/.npm-global";
  npmConf = pkgs.writeText "npmrc" ''
    prefix=${npmGlobalDir}
    cache=/home/cobray/.npm
    init-module=/home/cobray/.npm-init.js
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
      yarn
      bun
      deno
      nodePackages.eslint
      nodePackages.prettier
      nodePackages.sql-formatter
      nodePackages.markdownlint-cli
      nodePackages.stylelint
      nodePackages.htmlhint
      nodePackages.jsonlint
      nodePackages.pnpm
      nodePackages.typescript
    ];
    environment.variables = {
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
