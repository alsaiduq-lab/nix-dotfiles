{
  lib,
  python310Packages,
  fetchPypi,
  python-pymatting,
}:
python310Packages.buildPythonPackage rec {
  pname = "rembg";
  version = "2.0.50";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kW0MBDvIpL2Yc2n8zZ7Luw2na0qAczfORz2o6Y5YfkM=";
  };

  nativeBuildInputs = with python310Packages; [
    poetry-core
    setuptools
  ];

  propagatedBuildInputs = with python310Packages; [
    numpy
    pillow
    onnxruntime
    opencv-python
    requests
    aiohttp
    asynctest
    click
    filetype
    pooch
    pympler
    python-pymatting
    scikit-image
    scipy
    tqdm
  ];

  buildInputs = [
  ];

  doCheck = false;

  meta = with lib; {
    description = "Tool to remove image backgrounds";
    homepage = "https://github.com/danielgatis/rembg";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ "Cobray" ];
  };
}
