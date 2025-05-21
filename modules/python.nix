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

  gccLibPath = "${pkgs.gcc-unwrapped.lib}/lib";
  nvidiaLibPath = "${pkgs.linuxPackages.nvidia_x11}/lib";
  cudaLibPath = "${pkgs.cudatoolkit}/lib";
  ldLibraryPath = "${gccLibPath}:${nvidiaLibPath}:${cudaLibPath}";

  pythonEnv = pkgs.python311.buildEnv.override {
    extraLibs = with py; [
      customPkgs.python-rembg
      i3ipc
      requests
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
      wheel
    ];
    extraOutputsToInstall = ["out"];
    postBuild = ''
      wrapProgram $out/bin/python \
        --prefix LD_LIBRARY_PATH : "${ldLibraryPath}"
    '';
  };

  custom-UV = pkgs.symlinkJoin {
    name = "uv";
    paths = [pkgs.uv];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/uv \
        --prefix LD_LIBRARY_PATH : "${ldLibraryPath}" \
        --set PYTHONPATH ""
    '';
  };
in {
  options.python = {
    enable = lib.mkEnableOption "System Python Environment";
  };
  config = lib.mkIf config.python.enable {
    environment.systemPackages = with pkgs; [
      pythonEnv
      isort
      custom-UV
      git
      stdenv.cc.cc.lib
      python311
    ];
    environment.variables = {
      PIP_CONFIG_FILE = "${pipConf}";
      LD_LIBRARY_PATH = lib.mkForce "${ldLibraryPath}";
    };
  };
}
