{ lib, stdenv, fetchFromGitHub, fetchPypi, python310, numpy, pillow, opencv4, requests, onnxruntime }:

python310.pkgs.buildPythonPackage rec {
  pname = "rembg";
  version = "2.0.50";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dgq291bj4w6jkcyz7lvp1vba2nczfnmxa2acl2sqib5p8cpzjvc";
  };

  propagatedBuildInputs = with python310.pkgs; [
    numpy
    pillow
    onnxruntime
    opencv4
    requests
  ];

  doCheck = false;

  meta = with lib; {
    description = "Tool to remove images background";
    homepage = "https://github.com/danielgatis/rembg";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [Cobray];
  };
}
