{ lib,
python311Packages,
fetchPypi,
python-pymatting,
python-opencv-headless
}:
python311Packages.buildPythonPackage rec {
  pname = "rembg";
  version = "2.0.50";
  format = "pyproject";
  src = fetchPypi {
    inherit pname version;
    sha256 = "bMt/GbplRawFZUqoXq37zAq1dribnu/ZlIYTuUIS+DU=";
  };
  nativeBuildInputs = with python311Packages; [
    poetry-core
    setuptools
  ];
  propagatedBuildInputs = with python311Packages; [
    onnxruntime
    pillow
    pooch
    scikit-image
    scipy
    tqdm
    aiohttp
    pytorch-bin
  ] ++ [
    python-opencv-headless
    python-pymatting
  ];
  pythonRemoveDeps = [ "opencv-python-headless" ];
  dontPrecompilePages = true;
  doInstallCheck = false;
  doCheck = false;
  meta = with lib; {
    description = "Tool to remove image backgrounds";
    homepage = "https://github.com/danielgatis/rembg";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ "Cobray" ];
  };
}
