{ lib
, python310Packages
, fetchPypi
}:

python310Packages.buildPythonPackage rec {
  pname = "opencv-python-headless";
  version = "4.9.0.80";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    dist = "cp310";
    abi = "cp310";
    platform = "manylinux_2_17_x86_64.manylinux2014_x86_64";
    hash = "sha256-a1uEcgIUu7qxcJCyX+4umIOGa4bsRdfgSBn6jO0PnoM=";
  };

  propagatedBuildInputs = with python310Packages; [
    numpy
  ];

  doCheck = false;

  pythonImportsCheck = [ "cv2" ];

  meta = with lib; {
    description = "Wrapper package for OpenCV python bindings";
    homepage = "https://github.com/opencv/opencv-python";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ "Cobray" ];
  };
}
