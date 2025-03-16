{ lib, python310Packages, fetchPypi }:

python310Packages.buildPythonPackage rec {
  pname = "pymatting";
  version = "1.1.13";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LNt8S++s3e9Netwt6ONKJy3mOdYIrlwKCGE9+kJTgQE="; # Updated hash
  };

  propagatedBuildInputs = with python310Packages; [
    numpy
    scipy
    pillow
    numba
  ];

  doCheck = false;

  meta = with lib; {
    description = "A library for alpha matting";
    homepage = "https://github.com/pymatting/pymatting";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
