{lib, python310Packages, fetchurl}:

python310Packages.buildPythonPackage rec {
  pname = "opencv-python-headless";
  version = "4.9.0.80";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/71/19/3c65483a80a1d062d46ae20faf5404712d25cb1dfdcaf371efbd67c38544/opencv_python_headless-4.9.0.80-cp37-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
    sha256 = "976656362d68d9f40a5c66f83901430538002465f7db59142784f3893918f3df";
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
