{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (python313.withPackages (ps:
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
        pynvim
        pkginfo
        pypresence
      ]))
    isort
    uv
    ruff
  ];
}
