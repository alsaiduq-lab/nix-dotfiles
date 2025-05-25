{
  lib,
  python311Packages,
  fetchPypi,
  stdenv,
  makeWrapper,
  cmake,
  pkg-config,
  cudaPackages,
  enableCuda ? false,
}:
python311Packages.buildPythonPackage rec {
  pname = "opencv-python-headless";
  version = "4.11.0.86";
  format = "other";
  src = fetchPypi {
    pname = "opencv-python-headless";
    inherit version;
    sha256 = "mW6ygspLQ+xqOXJBTeDiMx9dnNorQQkaSXOcGfuEN5g=";
  };
  nativeBuildInputs = with python311Packages;
    [
      cmake
      pkg-config
      makeWrapper
      scikit-build
    ]
    ++ lib.optionals enableCuda (with cudaPackages; [
      cudatoolkit
    ]);
  buildInputs = with python311Packages;
    [
      scikit-build
    ]
    ++ lib.optionals enableCuda (with cudaPackages; [
      cudatoolkit
      cudnn
    ]);
  propagatedBuildInputs = with python311Packages; [
    setuptools
    numpy
  ];
  dontUseCmakeConfigure = true;
  SKBUILD_CMAKE_ARGS =
    [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DBUILD_opencv_apps=OFF"
      "-DBUILD_EXAMPLES=OFF"
      "-DBUILD_TESTS=OFF"
      "-DBUILD_PERF_TESTS=OFF"
      "-DBUILD_DOCS=OFF"
      "-DOPENCV_GENERATE_PKGCONFIG=ON"
      "-DCMAKE_BUILD_PARALLEL_LEVEL=$(nproc)"
    ]
    ++ lib.optionals enableCuda [
      "-DWITH_CUDA=ON"
      "-DCUDA_TOOLKIT_ROOT_DIR=${cudaPackages.cudatoolkit}"
      "-DWITH_CUDNN=ON"
    ];
  postPatch = lib.optionalString enableCuda ''
    export LD_LIBRARY_PATH=${cudaPackages.cudatoolkit.lib}/lib:$LD_LIBRARY_PATH
  '';
  doCheck = false;
  pythonImportsCheck = ["cv2"];
  postFixup = ''
    wrapPythonProgramsIn "$out/lib/python3.11/site-packages" "${stdenv.cc.cc.lib}${lib.optionalString enableCuda ":${cudaPackages.cudatoolkit.lib}/lib"}"
  '';
  meta = with lib; {
    description = "Wrapper package for OpenCV python bindings (headless)${lib.optionalString enableCuda " with CUDA support"}";
    homepage = "https://github.com/opencv/opencv-python";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = ["Cobray"];
  };
}
