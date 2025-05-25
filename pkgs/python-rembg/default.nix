{
  lib,
  python311Packages,
  fetchPypi,
  python-pymatting,
  enableCuda ? false,
}:
python311Packages.buildPythonPackage rec {
  pname = "rembg";
  version = "2.0.66";
  format = "pyproject";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hRBoq0zMY6artJs69z/cZntx41tmWGM9E/0HSFWPvZk=";
  };
  nativeBuildInputs = with python311Packages; [
    poetry-core
    setuptools
  ];
  propagatedBuildInputs = with python311Packages;
    [
      onnxruntime
      pillow
      pooch
      scikit-image
      scipy
      tqdm
      aiohttp
      pytorch-bin
      (opencv4.override {enableCuda = enableCuda;})
    ]
    ++ [
      python-pymatting
    ];
  pythonRemoveDeps = ["opencv-python-headless"];
  dontPrecompilePages = true;
  doInstallCheck = false;
  doCheck = false;
  dontCheck = true;
  checkPhase = "echo 'Skipping tests'";
  meta = with lib; {
    description = "Tool to remove image backgrounds${lib.optionalString enableCuda " with CUDA support"}";
    homepage = "https://github.com/danielgatis/rembg";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = ["Cobray"];
  };
}
