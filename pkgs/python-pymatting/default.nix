{
  lib,
  python310Packages,
  fetchPypi,
}:
python310Packages.buildPythonPackage rec {
  pname = "pymatting";
  version = "1.1.13";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LNt8S++s3e9Netwt6ONKJy3mOdYIrlwKCGE9+kJTgQE=";
  };

  nativeBuildInputs = with python310Packages; [
    setuptools
    poetry-core
  ];

  propagatedBuildInputs = with python310Packages; [
    numpy
    scipy
    pillow
    numba
  ];

  buildInputs = [
  ];

  doCheck = false;

  meta = with lib; {
    description = "A library for alpha matting";
    homepage = "https://github.com/pymatting/pymatting";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ "Cobray" ];
  };
}
