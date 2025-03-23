{
  config,
  pkgs,
  lib,
  ...
}:
let
  customPkgs = import ../pkgs { inherit pkgs lib; };
in {
  options.custom.python = {
    enable = lib.mkEnableOption "System Python Env";
  };

  config = lib.mkIf config.custom.python.enable {
    environment.systemPackages = with pkgs; [
      (python311.withPackages (ps: with ps; [
        virtualenv
        (torch.override { cudaSupport = true; })
        torchvision
        torchaudio
        ipython
        i3ipc
        xlib
        six
        psutil
        pynvml
        pyqtgraph
        pyqt6
        numpy
        pandas
        matplotlib
        scipy
        requests
        click
        typer
        rich
        pyyaml
        pytz
        onnxruntime
        pillow
        timm
      ] ++ [ customPkgs.python-rembg ]))
      python3Packages.pip
      uv
      ruff
      black
    ];
  };
}
