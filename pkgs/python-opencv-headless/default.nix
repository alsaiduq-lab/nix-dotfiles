{ lib
, python310Packages
, fetchurl
}:

python310Packages.buildPythonPackage rec {
  pname = "opencv-python-headless";
  version = "4.11.0.86";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/dd/5c/c139a7876099916879609372bfa513b7f1257f7f1a908b0bdc1c2328241b/opencv_python_headless-4.11.0.86-cp37-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
    sha256 = "0yx58bpwl6bcsq3ikv5jzffvxyv663jcyxj9z7ghvx6ikp0jf2hf";
  };

  propagatedBuildInputs = with python310Packages; [
    numpy
  ];

  doCheck = false;

  meta = with lib; {
    description = "Wrapper package for OpenCV python bindings";
    homepage = "https://github.com/opencv/opencv-python";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ "Cobray" ];
  };
}
