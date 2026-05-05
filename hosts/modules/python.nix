{
  pkgs,
  lib,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (python313.withPackages (ps:
      with ps; [
        requests
        ipython
        six
        psutil
        pynvml
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

  environment.etc."uv/uv.toml".text = ''
    python-preference = "only-managed"
  '';
}
