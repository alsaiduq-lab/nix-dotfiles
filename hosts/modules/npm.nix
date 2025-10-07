{
  config,
  pkgs,
  lib,
  ...
}: {
  options.npm.enable = lib.mkEnableOption "npm setup";

  config = lib.mkIf config.npm.enable {
    environment.systemPackages = with pkgs; [
      nodejs_24
      nodePackages.npm
      yarn
      bun
      nodePackages.typescript
    ];
  };
}
