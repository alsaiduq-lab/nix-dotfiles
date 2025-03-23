{ config, pkgs, lib, ... }:

let
  customPkgs = pkgs.callPackage ../pkgs { inherit pkgs lib; };
in {
  options.python = {
    enable = lib.mkEnableOption "System Python Environment";
  };
  config = lib.mkIf config.python.enable {
    environment.systemPackages = with pkgs; [
      (python311.withPackages (pyPkgs: with pyPkgs; [
        numpy
        python-pymatting
        python-opencv-headless
        python-rembg
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
        click
        typer
        rich
        pyyaml
        pytz
        pillow
      ]))
      python3Packages.pip
      black
      ruff
      uv
    ];
    environment.variables = {
      PIP_PREFIX = "$HOME/.local";
      PYTHONPATH = "$HOME/.local/lib/python3.11/site-packages";
    };
    environment.shellAliases = {
      python = "python3.11";
    };
  };
}
