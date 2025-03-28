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
      customPkgs.python-pymatting
      customPkgs.python-opencv-headless
      customPkgs.python-rembg
      customPkgs.pythonPackages.numpy # should force the monkeypatch'd numpy
      i3ipc
      pandas
      matplotlib
      scipy
      requests
      pip
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
    ];
  };
in {
  options.python = {
    enable = lib.mkEnableOption "System Python Environment";
  };
  config = lib.mkIf config.python.enable {
    environment.systemPackages = with pkgs; [
      pythonEnv
      python3Packages.pip
      isort
      uv
      stdenv.cc.cc.lib
    ];
    environment.variables = {
      PIP_PREFIX = "$HOME/.local";
      PIP_CONFIG_FILE = "${pipConf}";
      PYTHONPATH = "$HOME/.local/lib/python3.11/site-packages";
    };
    system.userActivationScripts.removeNumpy2 = ''
      if [ -d "$HOME/.local/lib/python3.11/site-packages/numpy" ]; then
        echo "Removing NumPy from user packages to prevent conflicts..."
        rm -rf "$HOME/.local/lib/python3.11/site-packages/numpy"*
      fi
    '';
  };
}
