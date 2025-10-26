{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (python312.withPackages (ps:
      with ps; [
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
        datasets
        debugpy
        pynvim
        pkginfo
        pypresence
      ]))
    isort
    uv
    ruff
  ];
}
