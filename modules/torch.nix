{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.custom.torch;
in {
  options.custom.torch = {
    enable = mkEnableOption "PyTorch with CUDA support";
    cudaSupport = mkOption {
      type = types.bool;
      default = true;
    };
    package = mkOption {
      type = types.package;
      default = pkgs.python311Packages.torch.override { cudaSupport = cfg.cudaSupport; };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (python3.withPackages (ps: with ps; [
        cfg.package
        numpy
      ]))
    ];
  };
}
