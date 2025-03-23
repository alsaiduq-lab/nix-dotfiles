{ lib
, python311Packages
, fetchPypi
, stdenv
, makeWrapper
, cmake
, pkg-config
}:

python311Packages.buildPythonPackage rec {
  pname = "opencv-python-headless";
  version = "4.11.0.86";
  format = "setuptools";

  src = fetchPypi {
    pname = "opencv-python-headless";
    inherit version;
    format = "setuptools";
    sha256 = "mW6ygspLQ+xqOXJBTeDiMx9dnNorQQkaSXOcGfuEN5g=";
  };

  nativeBuildInputs = with python311Packages; [
    cmake
    pkg-config
    makeWrapper
    scikit-build
  ];

  buildInputs = with python311Packages; [
    scikit-build
  ];

  propagatedBuildInputs = with python311Packages; [
    numpy
    setuptools
  ];

  dontUseCmakeConfigure = true;

  doCheck = false;

  pythonImportsCheck = [ "cv2" ];

  postFixup = ''
    wrapPythonProgramsIn "$out/lib/python3.11/site-packages" "${stdenv.cc.cc.lib}"
  '';

  meta = with lib; {
    description = "Wrapper package for OpenCV python bindings (headless)";
    homepage = "https://github.com/opencv/opencv-python";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ "Cobray" ];
  };
}
