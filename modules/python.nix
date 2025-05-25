{
  config,
  pkgs,
  lib,
  ...
}: let
  py = pkgs.python311Packages;
  gccLibPath = "${pkgs.gcc-unwrapped.lib}/lib";
  nvidiaLibPath = "${pkgs.linuxPackages.nvidia_x11}/lib";
  cudaLibPath = "${pkgs.cudatoolkit}/lib";
  glvndLibPath = "${pkgs.libglvnd}/lib";
  ldLibraryPath = "${gccLibPath}:${nvidiaLibPath}:${cudaLibPath}:${glvndLibPath}";
  pythonEnv = pkgs.python311.buildEnv.override {
    extraLibs = with py; [
      numpy
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
      jupyterlab
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
  };
}
