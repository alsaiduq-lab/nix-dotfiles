{
  config,
  pkgs,
  lib,
  ...
}: let
  customPkgs = pkgs.callPackage ../pkgs {inherit pkgs lib;};
  py = pkgs.python311Packages;
  pipConf = pkgs.writeText "pip.conf" ''
    [global]
    no-cache-dir = false
    [install]
    ignore-installed = false
    [packages]
    numpy = "<2.0.0"
  '';
  pythonEnv = pkgs.python311.buildEnv.override {
    extraLibs = with py; [
      customPkgs.python-rembg
      i3ipc
      requests
      virtualenv
      ipython
      six
      psutil
      pynvml
      pyqtgraph
      pyqt6
      pyyaml
      pillow
      jedi
      libcst
      pip
    ];
  };
in {
  options.python = {
    enable = lib.mkEnableOption "System Python Environment";
  };
  config = lib.mkIf config.python.enable {
    environment.systemPackages = with pkgs; [
      pythonEnv
      isort
      uv
      git
      stdenv.cc.cc.lib
      python311
    ];
    environment.variables = {
      PIP_CONFIG_FILE = "${pipConf}";
    };
  };
}
