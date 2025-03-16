{ lib, python310Packages, fetchPypi }:

python310Packages.buildPythonPackage rec {
  pname = "rembg";
  version = "2.0.50";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dgq291bj4w6jkcyz7lvp1vba2nczfnmxa2acl2sqib5p8cpzjvc";
  };

  nativeBuildInputs = with python310Packages; [
    setuptools
    poetry-core
  ];

  propagatedBuildInputs = with python310Packages; [
    numpy
    pillow
    onnxruntime
    opencv4
    requests
    aiohttp
    asynctest
    click
    filetype
    pooch
    pympler
    scikit-image
    scipy
    tqdm
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
