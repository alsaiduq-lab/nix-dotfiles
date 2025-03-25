{ config, pkgs, lib, ... }:

let
  customPkgs = pkgs.callPackage ../pkgs { inherit pkgs lib; };
  pipConf = pkgs.writeText "pip.conf" ''
    [global]
    no-cache-dir = false
    [install]
    ignore-installed = false
    [packages]
    numpy = "<2.0.0"
  '';
  pythonEnv = pkgs.python311.buildEnv.override {
    extraLibs = [
      customPkgs.python-pymatting
      customPkgs.python-opencv-headless
      customPkgs.python-rembg
      customPkgs.pythonPackages.numpy  # This should be numpy 1.x
      pkgs.python311Packages.i3ipc
      pkgs.python311Packages.pandas
      pkgs.python311Packages.matplotlib
      pkgs.python311Packages.scipy
      pkgs.python311Packages.requests
      pkgs.python311Packages.pip
      pkgs.python311Packages.virtualenv
      pkgs.python311Packages.ipython
      pkgs.python311Packages.six
      pkgs.python311Packages.psutil
      pkgs.python311Packages.pynvml
      pkgs.python311Packages.pyqtgraph
      pkgs.python311Packages.pyqt6
      pkgs.python311Packages.cppcheck
      pkgs.python311Packages.click
      pkgs.python311Packages.typer
      pkgs.python311Packages.rich
      pkgs.python311Packages.pyyaml
      pkgs.python311Packages.pytz
      pkgs.python311Packages.pillow
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
      black
      ruff
      uv
      stdenv.cc.cc.lib
    ];
    # Environment variables
    environment.variables = {
      PIP_PREFIX = "$HOME/.local";
      PIP_CONFIG_FILE = "${pipConf}";  # Force pip to use our config
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
